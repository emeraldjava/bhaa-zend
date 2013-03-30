<?php
class StandardsController extends Zend_Controller_Action
{
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();

        ZendX_JQuery::enableView($this->view);
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
       	$this->_helper->redirector('table', 'standards');
    }

    public function adminAction()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
		$eventsTable = new Model_DbTable_Event();
		$this->view->events = $eventsTable->getPastEvents(25);
    }
    
    public function paceAction()
    {
        $raceresultdata = new Model_DbTable_RaceResult();
        $this->view->minMaxStdData = $raceresultdata->getAllNormalisedPaces();
//        $config = new Zend_Config_Ini(APPLICATION_PATH.'/grids/grid.ini', 'production');
//        $db = Zend_Registry::get("db");
//        $grid = Bvb_Grid::factory('Table',$config,$id='');
//        $grid->setImagesUrl('/public/images');
//        $grid->setSource(new Bvb_Grid_Source_Zend_Select($raceresultdata->getAllNormalisedPacesSQL()));
//
//        //CRUD Configuration
//        $form = new Bvb_Grid_Form();
//        $form->setAdd(false)->setEdit(false)->setDelete(false);
//        $grid->updateColumn('standard',array('search'=>false));
//        $grid->setForm($form);
//
//        $grid->setParam('name','Standard Paces');
//        $grid->setExport(array('pdf'));
//        $grid->setPagination((int)30);
//
//        $this->view->grid = $grid->deploy();

    }

    public function tableAction()
    {
        $standard = $this->_request->getParam('standard',10);
        $distances = $this->_request->getParam('distances',array('1k','1m','2m','5k','4m','5m','10k','10m','half','mar'));
        $type = $this->_request->getParam('type','time');
        $slopex = $this->_request->getParam('slopex',1);
        $kmx = $this->_request->getParam('kmx',0);

        $cache = Zend_Registry::get('cache');
        $standardTableKey = sprintf("standardtable");
        if(!$standardTable = $cache->load($standardTableKey))
        {
            $standardtable = new Model_DbTable_Standard();
            //$this->view->table = $standardtable->standardsTable($standard,$distances,$type,$slopex,$kmx);
            $standardTable = $standardtable->standardsTable($distances);

            $cache->save($standardTable, $standardTableKey);
        }
        $this->view->table = $standardTable;

        $this->view->standard = $standard;
        $this->view->distances = $distances;
        $this->view->type = $type;
        $this->view->kmx = $kmx;
        $this->view->slopex = $slopex;
    }

    public function eventAction()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
    	$tag = $this->_request->getParam('tag');

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEventByTag($tag);
        $this->view->event = $event;

        $raceTable = new Model_DbTable_Race();
        $this->view->races = $raceTable->getEventRaces($event->id);
    }

    public function reportAction()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
    	$raceid = $this->getRequest()->getParam('race');
        $this->view->raceid = $raceid;

        $raceTable = new Model_DbTable_Race();
        $race = $raceTable->getRace($raceid);
        $this->view->race = $race;

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEvent($race->event);
        $this->view->event = $event;

        $raceResultTable = new Model_DbTable_RaceResult();
        $raceresults =  $raceResultTable->getRaceResults($raceid);
        
       	$page=$this->_getParam('page',1);
       	$this->view->page = $page;
       	 
    	$paginator = Zend_Paginator::factory($raceresults);
    	$paginator->setItemCountPerPage(30);
    	$paginator->setCurrentPageNumber($page);

    	$this->view->paginator=$paginator;
    }
    
    public function setstandardAction()
    {
        $race = $this->getRequest()->getParam('race');
        $runner = $this->getRequest()->getParam('runner');
        $standard = $this->getRequest()->getParam('standard');
		$page = $this->getRequest()->getParam('page',1);
		   	
    	$command = sprintf("CALL applyNewRunnerStandard(%d,%d,%d)",$race,$runner,$standard);
    	
    	$start = microtime(true);
    	$db = Zend_Db_Table::getDefaultAdapter();
    	$stmt = $db->prepare($command);
    	$stmt->execute();
    	$stmt->closeCursor();
    	$stop = microtime(true);
    	$logger = Zend_Registry::get('logger');
    	$time = ($stop-$start);
    	$logger->info(sprintf('action: %s => %f ms',$command,$time));
    	
    	$cache = Zend_Registry::get('cache');
    	$cache->clean(Zend_Cache::CLEANING_MODE_MATCHING_TAG,array($runner));
    	
        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('report','standards', 'default',array('race'=>$race,'page'=>$page));
    }
    
	public function graphAction()
    {
        $this->_helper->authRedirector->saveRequestUri();
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
    	$raceid = $this->_request->getParam('race');
        $this->view->raceid = $raceid;

        $raceTable = new Model_DbTable_Race();
        $race = $raceTable->getRace($raceid);
        $this->view->race = $race;

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEvent($race->event);
        $this->view->event = $event;

        $raceResultTable = new Model_DbTable_RaceResult();
        $raceresults =  $raceResultTable->getTimes($raceid);
        $this->view->raceresults = $raceresults;

    	$racetimestandardTable = new Model_DbTable_RaceStandardData();
        $this->view->standardtimes = $racetimestandardTable->getRaceStandardData($raceid);

        //$runnerTimesRowSet = $racetimestandardTable->getRunnerTimeStandardReport($raceid);
        //$this->view->runnerTimesRowSet = $runnerTimesRowSet;
    }

    public function populateAction()
    {
        $racesTable = new Model_DbTable_Race();
        $limit = $this->_request->getParam('limit',10);
        $races = $racesTable->getAdminRaceDetails($limit);

        $logger = Zend_Registry::get('logger');
    	$logger->info(sprintf('populateAction(%d)',$limit));

        $racetimestandardtable = new Model_DbTable_RaceStandardData();
        foreach($races as $race)
        {
            // delete existing data
            $racetimestandardtable->delete(sprintf('race=%d',$race->id));
            // update all standards
            $racetimestandardtable->populateRaceDetails($race->id);
            // remove results where no runners in standard
            $racetimestandardtable->delete(sprintf('runners=0 AND race=%d',$race->id));
        }
        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimple('index','standards','default',array('tag' => $tag));
    }

    public function perstandardreportAction()
    {
        $standard = $this->_request->getParam('standard',10);
        $this->view->standard = $standard;

        $racetimestandardtable = new Model_DbTable_RaceStandardData();
        $this->view->racestandarddata = $racetimestandardtable->fetchAll(sprintf("standard = %d",$standard));

        $raceresultdata = new Model_DbTable_RaceResult();
        $this->view->timepacedistanceforstandard = $raceresultdata->getRaceTimePaceDistanceForStandard($standard);

        $table = new Model_DbTable_StandardDistance();
        $this->view->standarddata = $table->getStandardPaceTimeForStandard($standard);

    }
    
    public function insertAction()
    {
        $tag = $this->_request->getParam('tag');
        $race = $this->_request->getParam('race');

        $racetimestandardtable = new Model_DbTable_RaceStandardData();
        $racetimestandardtable->delete(sprintf('race=%d',$race));

        $db = Zend_Db_Table::getDefaultAdapter();

        $SQL = sprintf(
            "INSERT INTO racestandarddata
            select
            coalesce(race.id,%d) as race,
            sd.standard as standard,
            count(rr.runner) as runners,
            coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ),0) as t_expected,
            coalesce(min(rr.racetime),0) as t_min,
            coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.racetime))),0) as t_avg,
            coalesce(max(rr.racetime),0) as t_max,
            IF(count(rr.runner)=0,0,
            ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(X.distance,X.unit)*slopefactor))*getRaceDistanceKM(X.distance,X.unit) ,0) -
            (coalesce( avg(TIME_TO_SEC(rr.racetime)),0)),0) ) as t_exp_avg_diff,
            coalesce(SEC_TO_TIME((oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor))),0) as p_expected,
            coalesce(min(rr.paceKM),0) as p_min,
            coalesce(SEC_TO_TIME(avg(TIME_TO_SEC(rr.paceKM))),0) as p_avg,
            coalesce(max(rr.paceKM),0) as p_max,
            IF(count(rr.runner)=0,0,
            ROUND(coalesce( (oneKmTimeInSecs + (getRaceDistanceKM(race.distance,race.unit)*slopefactor)) ,0) -
            (coalesce( avg(TIME_TO_SEC(rr.paceKM)),0)),0) ) as p_exp_avg_diff
            from standard sd
            left join  raceresult rr on rr.standard = sd.standard and rr.race=%d
            left join  race  on rr.race = race.id
            join (select race.id,race.distance,race.unit from race where id=%d) X on coalesce(race.id,%d)=X.id
            group by sd.standard;",
            $race,$race,$race,$race);
        $db->query($SQL);

        $SQL = sprintf(
            "DELETE from racestd where race = %d",$race);
        $db->query($SQL);

        $SQL = sprintf(
            "INSERT into racestd(race,avgdiff) select race,AVG(t_exp_avg_diff) from racestandarddata where race=%d",$race);
        $db->query($SQL);

//        $SQL = sprintf(
//            "update racetimestandard
//            join standard on racetimestandard.standard=standard.id
//            join racestd on racestd.race=racetimestandard.race
//            set factored=(SEC_TO_TIME(TIME_TO_SEC(expected)+((avgdiff*-1)*fudge)))
//            where racetimestandard.race=%d",$race);
//        $db->query($SQL);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimple('event','standards','default',array('tag' => $tag));
    }

    //
//    public function indexAction()
//    {
// 	    $this->view->title = "Standards";
//
//		$standardsTable = new Model_DbTable_Standards();
//		$rows = $standardsTable->getStandards();
//		$this->view->standards = $rows;
//    }
//    public function indexAction()
//    {
//		$eventsTable = new Model_DbTable_Event();
//		$this->view->events = $eventsTable->getPastEvents();
//
//		$racestandardTable = new Model_DbTable_RaceStandard();
//    	$this->view->standards = $racestandardTable->getRaceStandards(80);
//    }
//
//    public function racesAction()
//    {
//    	$tag = $this->_request->getParam('event');
//
//        $eventTable = new Model_DbTable_Event();
//        $event = $eventTable->getEvent($tag);
//        $this->view->event = $event;
//
//        $raceTable = new Model_DbTable_Race();
//        $this->view->races = $raceTable->getEventRaces($event->id);
//    }
//
//    public function reportAction()
//    {
//    	$race = $this->_request->getParam('race');
//    	$racestandardTable = new Model_DbTable_RaceStandard();
//    	$this->view->standards = $racestandardTable->getRaceStandards($race);
//
//    	$this->view->runners = $racestandardTable->getRunnerStandardReport($race);
//    }
//
//    public function runnersAction()
//    {
//    	$race = $this->_request->getParam('race');
//    	$racestandardTable = new Model_DbTable_RaceStandard();
//    	$this->view->standards = $racestandardTable->getRunnerStandardReport($race);
//    }
}
?>