<?php
class EventController extends Zend_Controller_Action
{
	var $logger;
	
    function init()
    {
    	$ajaxContext = $this->_helper->getHelper('AjaxContext');
        $ajaxContext
        	->addActionContext('eventsbyyear','html')
        	->addActionContext('raceresult','html')
        	//->addActionContext('teamresult','html')
            ->addActionContext('volunteers','html')
        	->addActionContext('summaryresult','html')
        	->initContext();
    	             
        $this->logger = Zend_Registry::get('logger');
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
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
    	$start = microtime(true);
        $tag = $this->_request->getParam('tag');
		
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($tag);
        $this->view->event = $event;
        
        if(!isset($event->id))
        {
            $redirector = $this->_helper->getHelper('redirector');
            $redirector->gotoSimpleAndExit('list','event');
        }
        
        $cache = Zend_Registry::get('cache');
        $getEventRaces = sprintf("%sGetEventRaces",$event->tag);
        if(!$races = $cache->load($getEventRaces))
        {
           $raceTable = new Model_DbTable_Race();
           $races = $raceTable->getEventRaces($event->id);
           $cache->save($races,$getEventRaces,array((string)$event->tag,"getEventRaces"));
        }
        $this->view->races = $races;

        if($event->id >= 201030)
        {
            $getEventStandards = sprintf("%sGetEventStandards",$event->tag);
            if(!$standards = $cache->load($getEventStandards))
            {
               $table = new Model_DbTable_Standard();
               $standards = $table->getEventStandardTable($races);
               $cache->save($standards, $getEventStandards,array((string)$event->tag,"getEventStandardTable"));
            }
            $this->view->standards = $standards;
            
           	$pointsTable = new Model_DbTable_RacePoints();
	    	//$this->view->runners = $pointsTable->runnersPerStandardAtRace($event->mensrace,"M");
			//$this->view->scoringsets = $pointsTable->scoringSetsPerStandardAtRace($event->mensrace,"M");
	    	//$this->view->wrunners = $pointsTable->runnersPerStandardAtRace($event->womensrace,"W");
			//$this->view->wscoringsets = $pointsTable->scoringSetsPerStandardAtRace($event->womensrace,"W");
        }
        
        $getEventResults = sprintf("%sGetEventResults",$event->tag);
        if(!$results = $cache->load($getEventResults))
        {
           $table = new Model_DbTable_RaceResult();
           $results = $table->getEventResults($event->id);
           $cache->save($results, $getEventResults,array((string)$event->tag,"getEventResults"));
        }
        $this->view->results = $results;

        $getEventVolunteers = sprintf("%sGetEventVolunteers",$event->tag);
        if(!$volunteers = $cache->load($getEventVolunteers))
        {
           $table = new Model_DbTable_RaceResult();
           $volunteers = $table->getEventVolunteers($event->id);
           $cache->save($volunteers, $getEventVolunteers,array((string)$event->tag,"getEventVolunteers"));
        }
        $this->view->volunteers = $volunteers;

        $table = new Model_DbTable_RaceResult();
        //$this->view->preregistered = $table->getRacePreRegistered($event);

        $getAllEventTeamResults = sprintf("%sGetAllEventTeamResults",$event->tag);
        if(!$teamresults = $cache->load($getAllEventTeamResults))
        {
           $teamRaceResultTable = new Model_DbTable_TeamRaceResult();
           $teamresults = $teamRaceResultTable->getAllEventTeamResults($event->id);
           $cache->save($teamresults, $getAllEventTeamResults,array((string)$event->tag,"getAllEventTeamResults"));
        }
        $this->view->teamresults = $teamresults;
        
        $flickrcache = Zend_Registry::get('flickrcache');
      	//$this->view->flickrPlugin = $flickrcache->load($tag);
      	$stop = microtime(true);
      	$this->logger->log(sprintf("event %s index %fms",$tag,($stop-$start)),Zend_Log::INFO);
      	$this->view->logger=$this->logger;
      	
      	$cache = Zend_Registry::get('cache');
      	$this->view->cachedTags = $cache->getIdsMatchingTags(array($event->tag));
      	$this->view->messages = $this->_helper->FlashMessenger->getMessages();
    }
    
    public function cleartagAction()
    {   	
    	$tag = $this->_request->getParam('tag');
    	$cache = Zend_Registry::get('cache');
    	$start = microtime(true);
    	$cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array($tag));
    	$stop = microtime(true);
    	$this->logger->info(sprintf('Clear cleartag cache %s %s : %f ms',Zend_Cache::CLEANING_MODE_MATCHING_TAG,$tag,($stop-$start)));
    	$redirector = $this->_helper->getHelper('redirector');
    	$redirector->gotoSimpleAndExit('index','event', 'default',array('tag'=>$tag));
    }
    
    public function runspAction()
    {
    	$this->_helper->authRedirector->saveRequestUri();
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    	$tag = $this->_request->getParam('tag');
    	$command = $this->_request->getParam('command');
    	
    	$sp = Zend_Registry::get('sp');
    	$time = $sp->action($command);
    	
    	$flashMessenger = $this->_helper->FlashMessenger;
    	$flashMessenger->addMessage(sprintf('Executed command "%s" in %fms.',$command,$time));

    	$redirector = $this->_helper->getHelper('redirector');
    	$redirector->gotoSimpleAndExit('index','event', 'default',array('tag'=>$tag));
    }
    
    public function listAction()
    {
        $year = $this->_request->getParam('year',Zend_Date::now()->get(Zend_Date::YEAR));
        $this->view->year = $year;

        $cache = Zend_Registry::get('cache');
        $getDistinctYears = sprintf("getDistinctYears");
        if(!$years = $cache->load($getDistinctYears))
        {
           $eventTable = new Model_DbTable_Event();
           $years = $eventTable->getDistinctYears();
           $cache->save($years, $getDistinctYears,array('events'));
        }
        $this->view->years = $years;

        $getEventsByYear = sprintf("getEventsByYear%s",$year);
        if(!$events = $cache->load($getEventsByYear))
        {
           $eventTable = new Model_DbTable_Event();
           $events = $eventTable->getEventsByYear($year);
           $cache->save($events, $getEventsByYear,array('events'));
        }
        $this->view->events = $events;
    }
    
    public function eventsbyyearAction()
    {
    	$year = $this->_request->getParam('year');
        $eventTable = new Model_DbTable_Event();
        $events = $eventTable->getEventsByYear($year);
        $this->view->events = $events;
    }
        
    public function resultsAction()
    {
		$tag = $this->_request->getParam('tag');
		
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($tag);
        $this->view->event = $event;
                
        $race = new Model_DbTable_Race();
        $this->view->races = $race->getEventRaces($event->id); 
        
        $teamRaceResultTable = new Model_DbTable_TeamRaceResult();
        $this->view->teamresults = $teamRaceResultTable->getTeamResultsForEvent($event->id);
    }
    
    public function raceresultAction()
    {
		$race = $this->_request->getParam('race');
		
        $racetable = new Model_DbTable_Race();
        $race = $racetable->getRace($race);
        $this->view->race = $race;
                        
        $table = new Model_DbTable_RaceResult();
        $this->view->results = $table->getRaceResults($race->id);
    }

    public function volunteersAction()
    {
        $tag = $this->_request->getParam('tag');

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($tag);

        $table = new Model_DbTable_RaceResult();
        $this->view->volunteers = $table->getEventVolunteers($event->id);
    }
    
//     public function teamsAction()
//     {
//         $tag = $this->_request->getParam('tag');

//         $eventTable = new Model_DbTable_Event();
//         $event = $eventTable->getEventByTag($tag);
//         $this->view->event = $event;

//         $teamRaceResultTable = new Model_DbTable_TeamRaceResult();
//         $this->view->teamresults = $teamRaceResultTable->getAllEventTeamResults($event->id);
//     }
    
    public function topthreeAction()
    {
		$tag = $this->_request->getParam('tag',20101);
        //$this->view->event = $event;

        $race=20104;
        $gender = "M";
        
//        $db = Zend_Db_Table::getDefaultAdapter();
//        $sql = $db->prepare(sprintf("CALL getallTop3byrace(%d,'%s')",$race,$gender));
//        $sql->execute();
//        $res = $sql->fetchAll();
//        $sql->closeCursor();
       
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($tag);
        $this->view->event = $event;

        $raceresultTable = new Model_DbTable_RaceResult();
        $this->view->men = $raceresultTable->getTopThree($event->id,"M");
        $this->view->women = $raceresultTable->getTopThree($event->id,"W");

        $this->view->men40 = $raceresultTable->getTopThreeByAge("M40",$event->id,"M");
        $this->view->men45 = $raceresultTable->getTopThreeByAge("M45",$event->id,"M");
        $this->view->men50 = $raceresultTable->getTopThreeByAge("M50",$event->id,"M");
        $this->view->men55 = $raceresultTable->getTopThreeByAge("M55",$event->id,"M");
        $this->view->men60 = $raceresultTable->getTopThreeByAge("M60",$event->id,"M");
        $this->view->men65 = $raceresultTable->getTopThreeByAge("M65",$event->id,"M");
        $this->view->men70 = $raceresultTable->getTopThreeByAge("M70",$event->id,"M");
        $this->view->men75 = $raceresultTable->getTopThreeByAge("M75",$event->id,"M");
        $this->view->men80 = $raceresultTable->getTopThreeByAge("M80",$event->id,"M");
        $this->view->men85 = $raceresultTable->getTopThreeByAge("M85",$event->id,"M");

        $this->view->women35 = $raceresultTable->getTopThreeByAge("W35",$event->id,"W");
        $this->view->women40 = $raceresultTable->getTopThreeByAge("W40",$event->id,"W");
        $this->view->women45 = $raceresultTable->getTopThreeByAge("W45",$event->id,"W");
        $this->view->women50 = $raceresultTable->getTopThreeByAge("W50",$event->id,"W");
        $this->view->women55 = $raceresultTable->getTopThreeByAge("W55",$event->id,"W");
        $this->view->women60 = $raceresultTable->getTopThreeByAge("W60",$event->id,"W");
        $this->view->women65 = $raceresultTable->getTopThreeByAge("W65",$event->id,"W");
        $this->view->women70 = $raceresultTable->getTopThreeByAge("W70",$event->id,"W");
        $this->view->women75 = $raceresultTable->getTopThreeByAge("W75",$event->id,"W");
        $this->view->women80 = $raceresultTable->getTopThreeByAge("W80",$event->id,"W");
        $this->view->women85 = $raceresultTable->getTopThreeByAge("W85",$event->id,"W");
    }

    public function daymemberAction()
    {
        $logger = Zend_Registry::get('logger');
        $request = $this->getRequest();

        $tag = $this->_request->getParam('tag');
        
//        $redirector = $this->_helper->getHelper('redirector');
//        $redirector->gotoSimpleAndExit('form','membership', 'default',array('type'=>'day','tag'=>$tag));
        
//        $metaTable = new Model_DbTable_Metadata();
//        $enabled = $metaTable->getMetadata(
//            Model_DbTable_Metadata::TYPE_ADMIN,
//            0,
//            Model_DbTable_Metadata::MEMBERSHIP_FORM);
//
//        if(isset($enabled->value) && ($enabled->value == Model_DbTable_Metadata::DISABLED) )
//            $this->_helper->redirector('suspended','membership');

        $model = new Model_DayMember();
        if ($request->isPost())
        {
            $userdata = $this->_request->getPost();

            $eventTable = new Model_DbTable_Event();
            $event = $eventTable->getEvent($userdata['eventid']);
            $this->view->event = $event;

            if($model->getForm()->isValid($userdata))
            {
                $preregid = $model->save($userdata);

                $SEND_MAIL = true;
                if($SEND_MAIL)
                {
                    // do whatever you need to do
                    $config = array('auth' => 'login',
                        'username' => 'registrar@bhaa.ie',
                        'password' => 'Passw0rd10',
                        'ssl' => 'tls',
                        'port' => 587);
                    $transport = new Zend_Mail_Transport_Smtp('smtp.gmail.com', $config);
                    $mail = new Zend_Mail();

                    $mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
                    $mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');
                    $mail->addTo($userdata['email']);
                    $mail->setSubject(
                        sprintf('%s %s : BHAA %s Race - Day Member Registration Form',
                            stripslashes($userdata['firstname']),
                            stripslashes($userdata['surname']),
                            $event->name));

                    $myView = new Zend_View();
                    $myView->firstname = $userdata['firstname'];
                    $myView->surname = $userdata['surname'];
                    $myView->gender = $userdata['gender'];
                    $myView->dateofbirth = $userdata['dateofbirth'];
                    $myView->address1 = $userdata['address1'];
                    $myView->address2 = $userdata['address2'];
                    $myView->address3 = $userdata['address3'];
                    $myView->email = $userdata['email'];
                    $myView->mobile = $userdata['mobile'];
                    $myView->companyname = $userdata['companyname'];
                    $myView->newsletter = $userdata['newsletter'];
                    $myView->textmessage = $userdata['textmessage'];
                    $myView->event = $event;
                    $myView->preregid = $preregid;
                    $myView->addScriptPath(APPLICATION_PATH . '/views/scripts/event');
                    $html_body = $myView->render('daymember.email.phtml');

                    $mail->setType(Zend_Mime::MULTIPART_RELATED);
                    $mail->setBodyHtml($html_body);
                    $mail->send($transport);
                }
                $redirector = $this->_helper->getHelper('redirector');
                $redirector->gotoSimpleAndExit('index','event', 'default',array('tag'=>$event->tag));
            }
            else
            {
                $model->getForm()->populate($userdata);
                $logger->info("Errors:".$model->getForm()->getMessages());
		        $this->view->errors = $model->getForm()->getMessages();
            }
        }
        else
        {
            $eventTable = new Model_DbTable_Event();
            $tag = $this->_request->getParam('tag');
            $event = $eventTable->getEventByTag($tag);
            $this->view->event = $event;
            $model->getForm()->eventid->setValue($event->id);
        }
        $this->view->model = $model;
    }   
    
    public function editresultAction()
    {
    	$race = $this->_request->getParam('race');
    	$runner = $this->_request->getParam('runner');
    	
    	$logger = Zend_Registry::get('logger');
    
    	$config = new Zend_Config_Ini(APPLICATION_PATH.'/configs/grid.ini', 'production');
    	$db = Zend_Registry::get("db");
    	$grid = Bvb_Grid::factory('Table',$config);
    	 
    	$table = new Model_DbTable_RaceResult();
	   	$grid->setSource(new Bvb_Grid_Source_Zend_Table($table));
    	 
    	//CRUD Configuration
    	$form = new Bvb_Grid_Form();
    	$form->setAdd(false)->setEdit(true)->setDelete(false);
    	
    	$grid->setForm($form);
    	$this->view->grid = $grid->deploy();
    }
    
    public function updatepositionsAction()
    {
    	$this->_helper->authRedirector->saveRequestUri();
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    	$tag = $this->_request->getParam('tag');
    	$race = $this->_request->getParam('race');
    	 
    	$sp = Zend_Registry::get('sp');
    	$time = $sp->updateRacePositions($race);
    	 
    	$flashMessenger = $this->_helper->FlashMessenger;
    	$flashMessenger->addMessage(sprintf('Executed updatePositions "%d" in %fms.',$race,$time));
    	
    	$redirector = $this->_helper->getHelper('redirector');
    	$redirector->gotoSimpleAndExit('index','event', 'default',array('tag'=>$tag));
    }
}
?>