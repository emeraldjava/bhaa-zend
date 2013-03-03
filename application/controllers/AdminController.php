<?php
#require_once 'BhaaStoredProcedure.php';

class AdminController extends Zend_Controller_Action
{
    var $sp;
    var $logger;

    function init()
    {
        ZendX_JQuery::enableView($this->view);

        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();

         // Optional added for consistency
        $this->logger = Zend_Registry::get('logger');
        $this->sp = Zend_Registry::get('sp');

        // Excel format context
        $excelConfig =
            array(
                'excel' => array(
                    'suffix'  => 'excel',
                    'headers' => array(
                        'Content-type' => 'application/vnd.ms-excel')),
            );

        // Init the Context Switch Action helper
        $contextSwitch = $this->_helper->contextSwitch();
        $contextSwitch->setContexts($excelConfig);
        $contextSwitch->addActionContext('excel','excel');
        $contextSwitch->initContext();

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
        $this->view->title = "Admin";
        $raceTable = new Model_DbTable_Race();
        $this->view->events = $raceTable->getAdminRaceDetails(25);

        $standardTable = new Model_DbTable_Standard();
        $this->view->missingStandards = $standardTable->getRunnersWithMissingStandards();
        //$this->view->renewedRunnersStandards = $standardTable->listRenewingRunnersStandard();

        $leagueTable = new Model_DbTable_League();
        $this->view->individualleague = $leagueTable->getCurrentLeague("I");
        $this->view->teamleague = $leagueTable->getCurrentLeague("T");

        $metaTable = new Model_DbTable_Metadata();
        $formStatus = $metaTable->getMetadata(
            Model_DbTable_Metadata::TYPE_ADMIN,
            0,
            Model_DbTable_Metadata::MEMBERSHIP_FORM);
        $this->view->formStatus = $formStatus;
        
        $cache = Zend_Registry::get('cache');
		$this->view->cachetags=$cache->getTags();
		$this->view->cacheids=$cache->getIds();
		
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getMostRecentEvent();
        $this->view->currentevent = $event;
        $this->view->nextevent = $eventTable->getNextEvent();
    }

    public function switchformstatusAction()
    {
        $metaTable = new Model_DbTable_Metadata();
        $formStatus = $metaTable->getMetadata(
            Model_DbTable_Metadata::TYPE_ADMIN,
            0,
            Model_DbTable_Metadata::MEMBERSHIP_FORM);

        if($formStatus->value == Model_DbTable_Metadata::ENABLED)
        {
            $metaTable->update(
                array('value'=>Model_DbTable_Metadata::DISABLED),
                "entity = '".Model_DbTable_Metadata::TYPE_ADMIN."' && name = '"
                .Model_DbTable_Metadata::MEMBERSHIP_FORM."'");
        }
        else
        {
            $metaTable->update(
                array('value'=>Model_DbTable_Metadata::ENABLED),
                "entity = '".Model_DbTable_Metadata::TYPE_ADMIN."' && name = '"
                .Model_DbTable_Metadata::MEMBERSHIP_FORM."'");
        }
       	$this->_helper->redirector('index', 'admin');
    }

    public function reloadeventAction()
    {
    	$eventid = $this->_request->getParam('event',0);
    	$this->logger->info(sprintf('reload event(%d)',$eventid));

    	$raceTable = new Model_DbTable_Race();
    	$races = $raceTable->getEventRaces($eventid);

    	foreach($races as $race)
    	{
    		$table = new Model_DbTable_RaceResult();
        	$table->deleteRaceResults($race->id);
        	$this->loadFile($race);
    	}
    	$this->logger->info(sprintf('reload event(%d) done',$eventid));
    	$this->_helper->redirector('index', 'admin');
    }
        
    public function updateraceresultAction()
    {
        $raceid = $this->_request->getParam('race');
        $start = microtime(true);
        $table = new Model_DbTable_RaceResult();
        $table->updateRaceCompanyDetails($raceid);
        $stop = microtime(true);
        $this->logger->info(sprintf('updateRaceCompanyDetails: %fms',($stop-$start)));
        //$this->sp->updateraceresultSPS($raceid);
    	$this->_helper->redirector('index', 'admin');
    }

    public function updateresultsbyeventAction()
    {
    	$event = $this->_request->getParam('event');
    	$this->logger->info(sprintf('start updateresultsbyeventAction(%d)',$event));
        $this->sp->updateResultsByEventId($event);
        $this->_helper->redirector('index', 'admin');
    }

    public function cleareventresultsdataAction()
    {
    	$event = $this->_request->getParam('event');
    	$this->logger->info(sprintf('start clearEventResultsData(%d)',$event));
        $this->sp->clearEventResultsData($event);
        $this->_helper->redirector('index', 'admin');
    }

    public function deleteraceresultsAction()
    {
    	$race = $this->_request->getParam('race');
    	$this->logger->info(sprintf('deleteraceresultsAction(%s)',$race));
    	$table = new Model_DbTable_RaceResult();
        $table->deleteRaceResults($race);
        $this->_helper->redirector('index', 'admin');
    }

    public function loadraceresultsAction()
    {
    	$id = $this->_request->getParam('race', 0);
        $racesTable = new Model_DbTable_Race();

    	$race = $racesTable->getRaceDetails($id);
   		$this->logger->info('start loadraceresultsAction()');

    	// if hibernian or trinity - write a hack
    	$this->view->number = $this->loadFile($race);
    	$this->view->race = $race;
    	$this->logger->info('done loadraceresultsAction()');
    	$this->_helper->redirector('index', 'admin');
    }

    private function loadFile($race)
    {
        $raceDate = $race->date;
        $this->logger->info(sprintf('loading race results from %s for race %d, event %d date %s',$race->file,$race->id,$race->event,$raceDate));


    	$handle = fopen($race->file, "r");
		if (!$handle) {
		    throw new Exception(sprintf("Problem loading file %s",$race->file));
		}
    	//$raceid=$race->id;
    	$runnerTable = new Model_DbTable_Runner();
    	$num;
		while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
			$num = count($data);

		    // Place,Race No,Member No,Time,Surname,Name,S,Std,DOB,Grade,Company,Company No,,Age,Grade Check,CTRL g to Check Grade,
		    $position = trim($data[0]);
            // racenumber
		    $racenumber = trim($data[1]);
            // membership id
		    $member = trim($data[2]);
            if(strlen($member)==0)
		    {
		        $member=null;
		    }
            // racetime
		    $time = trim($data[3]);
            // surname
		    $surname = trim($data[4]);
            // firstname
		    $firstname = trim($data[5]);
            // gender
            $gender = trim($data[6]);
		    if($gender != "M" )
		        $gender = "W";
		    // standard
		    $standard = trim($data[7]);
			if(strlen($standard)==0)
		    {
		        $standard=null;
		    }
            // dob
		    $dateofbirth = trim($data[8]);
		 	if(empty($dateofbirth))
		    {
		    	$this->logger->info(sprintf('missing date of birth %s %s %s',$member,$firstname,$surname));
		        $dateofbirth="29/02/1980";
		    }
            $dob = new Zend_Date($dateofbirth,'dd/mm/yyyy');
            //$logger->info($dob);
            
            // short age category code
		    $category = trim($data[9]);

			// company name
		    $company = trim($data[10]);
		    
		    // team id
            $teamid = $data[11];
		    if(strlen($teamid)==0)
		    {
		        $teamid=null;
		    }
		    
            // lookup the long age category
            $db = Zend_Db_Table::getDefaultAdapter();
            $sql = sprintf('select getAgeCategory("%s","%s","%s",%d) as agecat',$dob->toString('yyyy-mm-dd'),$raceDate,$gender,0);
            //$logger->info($sql);
            $stmt = $db->query($sql);
            $obj = $stmt->fetchObject();
            $agecategory = $obj->agecat;
            //$logger->info(sprintf('select getAgeCategory("%s","%s","%s",%d) as agecat ==> "%s"',$dob->toString('yyyy-mm-dd'),$raceDate,$gender,0,$agecategory));

		    // raceid - if overridden
// 		    $raceid=trim($data[12]);
// 		    if(!empty($raceid))
// 		    {
// 		    	$race->id = $raceid;
// 		    }
		    $this->logger->info(sprintf('%d process result %s %s %s %s %s %s',$position,$member,$firstname,$surname,$dob,$race->event,$company));

            if(!isset($member))
            {
                // insert new day member
                $runnerArray = array(
                    'surname' => $surname,
                    'firstname' => $firstname,
                    'gender' => $gender,
                    'standard' => null,
                    'dateofbirth' => $dob->toString('yyyy-mm-dd'),
                    'status' => 'D',
                    'insertdate' => $race->date);
                $member = $runnerTable->insert($runnerArray);
                $this->logger->info(sprintf('%d insert new day runner %d %s %s %s',$position,$member,$firstname,$surname,$dob->toString('yyyy-mm-dd')));
            }

		    $resultTable = new Model_DbTable_RaceResult();
		    $raceresultdata = array(
				'race' => $race->id,
		    	'runner' => $member,
		    	'racetime' => $time,
		    	'racenumber' => $racenumber,
		    	'position' => $position,
		    	'category' => $agecategory,
		    	'standard' => $standard,
				'companyname' => $company,
   				'company' => $teamid,
                'class'=>'RAN');
	   		$rr = $resultTable->insert($raceresultdata);
            $this->logger->info(sprintf('%d insert new race result %d %d %s %d',$position,$race->id,$member,$company,$teamid));
	   	}
		fclose($handle);
		return $num;
    }

	// http://stackoverflow.com/questions/1136264/export-csv-in-zend-framework
	// http://www.ineedtutorials.com/code/php/export-mysql-data-to-csv-php-tutorial
	// http://framework.zend.com/manual/en/zend.db.table.rowset.html
	public function exportAction()
    {
        $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNeverRender();

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getNextEvent();

        $letterStart = $this->_request->getParam('letterStart','A');
        $letterEnd = $this->_request->getParam('letterEnd','Z');
        $date = $this->_request->getParam('date','2012-01-01');
        $status = $this->_request->getParam('status','M');

        $fileName = sprintf("%s_%s%s_%s_%s",$event->tag,$letterStart,$letterEnd,$date,$status);
        $this->logger->info(sprintf('start exportAction(%s)',$fileName));

        $runnerTable = new Model_DbTable_Runner();
        $rowset = $runnerTable->exportRunnerData($event->date,$letterStart,$letterEnd,$date,$status);
        $rowsetArray = $rowset->toArray();

		$output = "";
		$columns = $rowsetArray[1];
		$output = $output."raceno,";
		foreach ($columns as $column => $value) {
			$output = $output.$column.",";
		}
		$output = $output."\n";

		foreach ($rowsetArray as $rowArray) {
			$output = $output.",";
		    foreach ($rowArray as $column => $value) {
		    	$output =  stripslashes($output.$value.",");
		    }
		    $output = $output."\n";
		}

        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header("Content-Length: " . strlen($output));
		header("Content-type: text/x-csv");
		header("Content-Disposition: attachment; filename=".$fileName.".csv");
		echo $output;
		exit;
	}

    public function updateteamsAction()
    {
        $db = Zend_Db_Table::getDefaultAdapter();
        $stmt = $db->prepare("CALL migrateCompany(2012-1-1)");
        $stmt->execute();
        $stmt->closeCursor();
        $this->_helper->redirector('index', 'admin');
    }

    public function exportrunirelandrunnersAction()
    {
        $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNeverRender();

	    $tag = $this->_request->getParam('tag');

        $runnerTable = new Model_DbTable_Runner();
        $this->logger->info("exportinactiveAction");
        $fileName = sprintf("%s_runireland",$tag);
        $this->logger->info(sprintf('exportrunirelandrunnersAction(%s)',$fileName));
        
        $rowset = $runnerTable->exportRunirelandData($tag);
        $rowsetArray = $rowset->toArray();
		$output = "";
		$columns = $rowsetArray[1];
		$output = $output."raceno,";
		foreach ($columns as $column => $value) {
			$output = $output.$column.",";
		}
		$output = $output."\n";

		foreach ($rowsetArray as $rowArray) {
			$output = $output.",";
		    foreach ($rowArray as $column => $value) {
		    	$output =  stripslashes($output.$value.",");
		    }
		    $output = $output."\n";
		}

        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header("Content-Length: " . strlen($output));
		header("Content-type: text/x-csv; charset=UTF-8");
		header("Content-Disposition: attachment; filename=".$fileName.".csv");
		echo $output;
		exit;
	}

    public function exportdaymembersAction()
    {
        $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNeverRender();

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getNextEvent();

        $fileName = $event->tag."_DayMembers";
        $this->logger->info(sprintf('start exportdaymembersAction(%s)',$fileName));

        $raceresulttable = new Model_DbTable_RaceResult();
        $rowset = $raceresulttable->getRacePreRegistered($event);
        $rowsetArray = $rowset->toArray();

		$output = "";

		$columns = $rowsetArray[1];
		foreach ($columns as $column => $value) {
			$output = $output.$column.",";
		}
		$output = $output."\n";

		foreach ($rowsetArray as $rowArray) {
			foreach ($rowArray as $column => $value) {
		    	$output =  stripslashes($output.$value.",");
		    }
		    $output = $output."\n";
		}

        header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
		header("Content-Length: " . strlen($output));
		header("Content-type: text/x-csv; charset=UTF-8");
		header("Content-Disposition: attachment; filename=".$fileName.".csv");

		echo $output;
		exit;
    }

    public function clearcacheAction()
    {
        $cache = Zend_Registry::get('cache');
        $start = microtime(true);
        $cache->clean(Zend_Cache::CLEANING_MODE_ALL);
        $stop = microtime(true);
        $this->logger->info(sprintf('Clear cache %s : %f ms',Zend_Cache::CLEANING_MODE_ALL,($stop-$start)));
        $this->_helper->redirector('index', 'admin');
    }
    
    public function cleartagAction()
    {
    	$tag = $this->_request->getParam('tag');
    	$cache = Zend_Registry::get('cache');
    	$start = microtime(true);
    	$cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array($tag));
    	$stop = microtime(true);
    	$this->logger->info(sprintf('Clear admin cache %s %s : %f ms',Zend_Cache::CLEANING_MODE_MATCHING_TAG,$tag,($stop-$start)));
    	$this->_helper->redirector('index', 'admin');
    }

    public function updateindividualleaguesummaryAction()
    {
        $league = $this->_request->getParam('league',0);
        $this->sp->updateIndividualLeagueSummary($league);
        $cache = Zend_Registry::get('cache');
        $cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array('leaguesummaryInd'.Zend_Date::now()->toString('yyyy')));
        $this->_helper->redirector('index', 'admin');
    }

    public function updateteamleaguesummaryAction()
    {
        $league = $this->_request->getParam('league',0);
        $this->sp->updateTeamLeagueSummary($league);
        $cache = Zend_Registry::get('cache');
        $cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array('leaguesummaryTeam'.Zend_Date::now()->toString('yyyy')));
        $this->_helper->redirector('index', 'admin');
    }

    public function staggeredAction()
    {
       	$event = $this->_request->getParam('event');
    	$this->logger->info(sprintf('start staggeredAction(%d)',$event));
        $this->sp->updateRaceTimeByHandicap($event);
        $this->_helper->redirector('index', 'admin');
    }
}
?>