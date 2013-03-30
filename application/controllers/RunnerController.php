<?php
require_once 'BhaaStoredProcedure.php';

class RunnerController extends Zend_Controller_Action
{
    protected $_redirector = null;
    var $logger;
    var $sp;

    function init()
    {
        $this->logger = Zend_Registry::get('logger');
        $this->sp = new BhaaStoredProcedure($this->logger);
        
        $this->_redirector = $this->_helper->getHelper('Redirector');
        //$this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
        
       // $this->_helper->ajaxContext()->addActionContext('runnerfilter','json')->initContext();
        $this->_helper->contextSwitch()
	        ->addActionContext('runnerfilter', array('json'))
	        ->setAutoJsonSerialization(false)
	        ->initContext();
    }
    
    function preDispatch()
    {
    	$this->_helper->authRedirector->saveRequestUri();
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    }
    
    public function runnerfilterAction()
    {
    		$runnername = $this->_request->getParam('q');
    		$this->view->callback = $this->_request->getParam('callback');
    		//$this->logger->info(Zend_Json::encode($runnername));
    		$runnerTable = new Model_DbTable_Runner();
    		$runners = $runnerTable->searchActiveRunnersByName($runnername)->toArray();
    		$this->logger->info($runnername.' '.count($runners));
    		$this->view->results = $runners;
    }
    
    public function indexAction()
    {
        $id = $this->_request->getParam('id');
        
        $runnerTable = new Model_DbTable_Runner();
        $runner->id = $runnerTable->getRunner($id);
        if(!isset($runner->id))
        {
        	$redirector = $this->_helper->getHelper('redirector');
        	$redirector->gotoSimpleAndExit('index','index');
        }
        
        $cache = Zend_Registry::get('cache');
        $runnerKey = sprintf("runnerDetails%d",$id);
        if(!$runner = $cache->load($runnerKey))
        {
        	$runnerTable = new Model_DbTable_Runner();
        	$runner = $runnerTable->getRunnerDetails($id);
        	$cache->save($runner,$runnerKey,array((string)$id,"runner"));
        }
        $this->view->runner = $runner;

        $runnerRaceKey = sprintf("runnerRaceResults%d",$id);
        if(!$results = $cache->load($runnerRaceKey))
        {
        	$runnerTable = new Model_DbTable_Runner();
        	$results = $runnerTable->getRunnerRaceResults($id);
        	$cache->save($results,$runnerRaceKey,array((string)$id));
        }
        $this->view->results = $results;
        
        $flickrcache = Zend_Registry::get('flickrcache');
      	$this->view->flickrPlugin = $flickrcache->load($id);

        if($runner->status=="D")
        {
        	$runnerTable = new Model_DbTable_Runner();
            $existing = $runnerTable->existingMember(
                $runner->firstname, $runner->surname, $runner->dateofbirth);
            $this->view->existing = $existing;
        }
   }

    public function editAction()
    {
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }

        $form = new Form_RunnerForm();
        if ($this->_request->isPost()) {

            $formData = $this->_request->getPost();
            if($form->isValid($formData))
            {
                $dob = new Zend_Date($formData['dateofbirth']);
                $standard = $formData['standard'];
                if($formData['standard']=='')
                {
                    $standard = NULL;
                }
                $table = new Model_DbTable_Runner();
                $mappeddata = array(
                        'firstname' => stripslashes($formData['firstname']),
                        'surname' => stripslashes($formData['surname']),
                        'address1' => $formData['address1'],
                        'address2' => $formData['address2'],
                        'address3' => $formData['address3'],
                        'standard' => $standard,
                        'gender' => $formData['gender'],
                        'company' => $formData['company'],
                        'team' => $formData['team'],
                        'dateofbirth' => $dob->toString('Y-M-d'),
                        'email' => $formData['email'],
                        'newsletter' => $formData['newsletter'],
                        'telephone' => $formData['telephone'],
                        'mobilephone' => $formData['mobilephone'],
                        'textmessage' => $formData['textmessage'],
                        'volunteer' => $formData['volunteer'],
                        'insertdate' => $formData['insertdate'],
                        'dateofrenewal' => $formData['dateofrenewal'],
                        'status' => $formData['status']);
                $table->update($mappeddata,"id = ".$this->_request->getParam('id'));
                $cache = Zend_Registry::get('cache');
                $cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array($this->_request->getParam('id')));
            }
            else
            {
                $form->populate($form->getValues());
                $this->view->errors = $form->getMessages();
            }
        }
        else
        {
            $id = $this->_request->getParam('id');
            $this->view->title = "Runners";
            $runnerTable = new Model_DbTable_Runner();
            $runner = $runnerTable->getRunner($id);
            $mappeddata = array(
                'id' => $runner->id,
                'firstname' => stripslashes($runner->firstname),
                'surname' => stripslashes($runner->surname),
                'gender' => $runner->gender,
                'standard' => $runner->standard,
                'company' => $runner->company,
                'dateofbirth' => date('d/m/Y',strtotime($runner->dateofbirth)),//$runner->dateofbirth,
                'team' => $runner->team,
                'address1' => $runner->address1,
                'address2' => $runner->address2,
                'address3' => $runner->address3,
                'email' => $runner->email,
                'newsletter' => $runner->newsletter,
                'telephone' => $runner->telephone,
                'mobilephone' => $runner->mobilephone,
                'textmessage' => $runner->textmessage,
                'volunteer' => $runner->volunteer,
                'insertdate' => $runner->insertdate,
                'dateofrenewal' => $runner->dateofrenewal,
                'status' => $runner->status
            );
            $form->populate($mappeddata);
        }
        $this->view->form = $form;
    }

    public function renewAction()
    {
        $id = $this->_request->getParam('id');

        $now = Zend_Date::now()->getIso();
        $table = new Model_DbTable_Runner();
        $mappeddata = array(
            'status'=>"M",
            'dateofrenewal' => $now
        );
        $runner = $table->getRunner($id);
        
        $table->update($mappeddata,"id = ".$id);
        
        $this->logger->info(sprintf('runner %s renewal date %s',$id,$now));
        
        
        	$config = Zend_Registry::get('config');
        	// do whatever you need to do
        	$emailconfig = array(
              	'auth' => $config->email->auth,
                'username' => $config->email->username,
                'password' => $config->email->password,
				'ssl' => $config->email->ssl,
                'port' => (int)$config->email->port);
        	$transport = new Zend_Mail_Transport_Smtp($config->email->smtp, $emailconfig);
        	Zend_Mail::setDefaultTransport($transport);
        	$mail = new Zend_Mail();
        	$mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
        	 
        	if(filter_var($runner->email, FILTER_VALIDATE_EMAIL))
        	{
        		// only send to runners with an email
        		$mail->addTo($runner->email);
        		$mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');
        	}
        	else
        	{
        		$mail->addTo('registrar@bhaa.ie');
        	}
       		$mail->setSubject(sprintf("BHAA Membership Renewal : %s %s",
       			stripslashes($runner->firstname),stripslashes($runner->surname)));
       		
        	$renewalView = new Zend_View();
        	$renewalView->subject = $subject;
        	$renewalView->id = $runner->id;
        	$renewalView->firstname = stripslashes($runner->firstname);
        	$renewalView->surname = stripslashes($runner->surname);
        	
        	$renewalView->addScriptPath(APPLICATION_PATH.'/views/scripts/runner');
        	$html_body = $renewalView->render('renewal.email.phtml');
        	
        	$mail->setType(Zend_Mime::MULTIPART_RELATED);
        	$mail->setBodyHtml($html_body);
        	$mail->send($transport);
        
        
        $cache = Zend_Registry::get('cache');
        $cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array($this->_request->getParam('id')));
        
        $this->_redirector->gotoSimple('index','runner',null,array('id' => $id));
    }

    public function transferdetailsAction()
    {
        $logger = Zend_Registry::get('logger');
        
        $id = $this->_request->getParam('id');
        $race = $this->_request->getParam('race');

        $runnerTable = new Model_DbTable_Runner();
    	$nextRunner = $runnerTable->getNextRunnerId();
        $newmemberid = $nextRunner->newid;
        $logger->info('transferdetailsAction('.$id.','.$newmemberid.','.$race.')');

        $daymember = $runnerTable->getRunner($id);

        $now = Zend_Date::now();
        $date = $now->toString('YYYY-MM-dd');

        $mappeddata = array(
            'id' => $newmemberid,
            'firstname' => $daymember->firstname,
            'surname' => $daymember->surname,
            'gender' => $daymember->gender,
            'dateofbirth' => $daymember->dateofbirth,
            'status' => "M",
            'standard'=> NULL,
            'company' => $daymember->company,
            'address1' => $daymember->address1,
            'address2' => $daymember->address2,
            'address3' => $daymember->address3,
            'email' => $daymember->email,
            'newsletter' => $daymember->newsletter,
            'telephone' => "",
            'mobilephone' => "",
            'textmessage' => $daymember->textmessage,
            'volunteer' => $daymember->volunteer,
            'insertdate' => $date,
            'dateofrenewal' => $date
            );
        $runnerTable->insert($mappeddata);

        $db = Zend_Db_Table_Abstract::getDefaultAdapter();
        $stmt = $db->prepare(sprintf(
                "UPDATE raceresult SET runner = %d where runner=%d and race=%d",$newmemberid,$id,$race));
        $stmt->execute();
        
        $runnerTable = new Model_DbTable_Runner();
        $runnerTable->delete(sprintf('id=%d',$id));
        //$runnerTable->delete(sprintf('id=%d',$id));
        //$this->logger->info("delete runner ".$id);
        
        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','runner', 'default',
            array('id'=>$newmemberid));
    }

    public function xtransferexistingAction()
    {
        $id = $this->_request->getParam('id');
        $existingid = $this->_request->getParam('existingid');

        $this->logger->info("id:".$id."->existing:".$existingid);

        $runnerTable = new Model_DbTable_Runner();
    	$existingmember = $runnerTable->getRunner($existingid);

        $now = Zend_Date::now();
        $date = $now->toString('YYYY-MM-dd');
        $logger->info("date ".$date);

        $mappeddata = array(
            'status' => "M",
            'dateofrenewal' => $date
            );
        $runnerTable->update($mappeddata,'id ='.$existingid);

        $db = Zend_Db_Table_Abstract::getDefaultAdapter();
        $stmt = $db->prepare(sprintf(
                "UPDATE raceresult SET runner=%d where runner=%d and race=%d",$existingid,$id,201016));
        $stmt->execute();

    	//$runner = $runnerTable->getRunner($id);
        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','runner', 'default',array('id'=>$existingid));
    }

    public function membershipAction()
    {
        $request = $this->getRequest();
        $model = new Model_Runner();
        if ($request->isPost())
        {
            $userdata = $this->_request->getPost();
            if($model->getForm()->isValid($userdata))
            {
                $model->save($userdata);

//                $SEND_MAIL = true;
//                if($SEND_MAIL)
//                {
//			    // do whatever you need to do
//			    $config = array('auth' => 'login',
//	                'username' => 'registrar@bhaa.ie',
//	                'password' => 'registrar09');
//				$transport = new Zend_Mail_Transport_Smtp('mail.bhaa.ie', $config);
//				Zend_Mail::setDefaultTransport($transport);
//				$mail = new Zend_Mail();
//
//                $mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
//				$mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');
//				$mail->addTo($userdata['email']);
//				$mail->setSubject(
//                    sprintf('%s %s : BHAA %s Race - Day Member Registration Form',
//                        stripslashes($userdata['firstname']),
//                        stripslashes($userdata['surname']),
//                        $event->name));
//
//				$myView = new Zend_View();
//				$myView->firstname = $userdata['firstname'];
//				$myView->surname = $userdata['surname'];
//				$myView->gender = $userdata['gender'];
//				$myView->dateofbirth = $userdata['dateofbirth'];
//				$myView->address1 = $userdata['address1'];
//				$myView->address2 = $userdata['address2'];
//				$myView->address3 = $userdata['address3'];
//				$myView->email = $userdata['email'];
//				$myView->mobile = $userdata['mobile'];
//                $myView->companyname = $userdata['companyname'];
//		        $myView->newsletter = $userdata['newsletter'];
//		        $myView->textmessage = $userdata['textmessage'];
//				$myView->event = $event;
//				$myView->addScriptPath(APPLICATION_PATH . '/views/scripts/registration');
//				$html_body = $myView->render('preregistrationemail.phtml');
//
//				$mail->setType(Zend_Mime::MULTIPART_RELATED);
//				$mail->setBodyHtml($html_body);
//	        	$mail->send($transport);
//                }
//                return $this->_forward('confirmdaymember');
                return $this->_forward('index');
            }
            else
            {
                $model->getForm()->populate($userdata);
                $this->view->errors = $model->getForm()->getMessages();
            }
        }
        else
        {
            $eventTable = new Model_DbTable_Runner();
            $tag = $this->_request->getParam('id');
            $event = $eventTable->getRunner($id);
            $this->view->event = $event;
            $model->getForm()->popeventid->setValue($event->id);
        }
        $this->view->model = $model;
    }

    public function addraceorganiserAction()
    {
        $id = $this->_request->getParam('id');

        $runnerTable = new Model_DbTable_Runner();
        $runner = $runnerTable->getRunner($id);

        $eventTable = new Model_DbTable_Event();
        $currentEvent = $eventTable->getMostRecentEvent();

        $leagueTable = new Model_DbTable_League();
        $currentLeague = $leagueTable->getCurrentLeague();

        if($runner->gender=="M")
            $this->sp->addRaceOrganiser($currentLeague->id, $currentEvent->mensrace, $runner->id);
        else
            $this->sp->addRaceOrganiser($currentLeague->id, $currentEvent->womensrace, $runner->id);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','runner', 'default',array('id'=>$runner->id));
    }

    public function addracevolunteerAction()
    {
        $id = $this->_request->getParam('id');

        $runnerTable = new Model_DbTable_Runner();
        $runner = $runnerTable->getRunner($id);

        $eventTable = new Model_DbTable_Event();
        $currentEvent = $eventTable->getMostRecentEvent();

        $leagueTable = new Model_DbTable_League();
        $currentLeague = $leagueTable->getCurrentLeague();

        if($runner->gender=="M")
            $this->sp->addRaceVolunteer($currentLeague->id, $currentEvent->mensrace, $runner->id);
        else
            $this->sp->addRaceVolunteer($currentLeague->id, $currentEvent->womensrace, $runner->id);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','runner', 'default',array('id'=>$runner->id));
    }

    public function grideditAction()
    {
        $id = $this->_request->getParam('id');
        $config = new Zend_Config_Ini(APPLICATION_PATH.'/configs/grid.ini', 'production');

        $db = Zend_Registry::get("db");

        $grid = Bvb_Grid::factory('Table',$config,$x='');

        $table = new Model_DbTable_Runner();
        $sql = $table->select()->from(array('runner'=>'runner'))->where('runner.id = ?',$id);
        $grid->setSource(new Bvb_Grid_Source_Zend_Select($sql));

        //CRUD Configuration
        $form = new Bvb_Grid_Form();
        $form->setAdd(false)->setEdit(true)->setDelete(false);

        $grid->setForm($form);

        $grid->setPagination(1);
        $grid->setExport(array());
        $this->view->grid = $grid->deploy();
    }
    
    public function deleteAction()
    {
		$auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
        $id = $this->_request->getParam('id');
        $runnerTable = new Model_DbTable_Runner();
    	$runnerTable->delete(sprintf('id=%d',$id));
    	$this->logger->info("delete runner ".$id);
    	
    	$redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','index');
    }
    
    public function clearcacheAction()
    {
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    	$id = $this->_request->getParam('id');
    	$cache = Zend_Registry::get('cache');
    	$cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array($id));
    	
    	$redirector = $this->_helper->getHelper('redirector');
    	$redirector->gotoSimpleAndExit('index','runner', 'default',array('id'=>$id));
    }
}
?>