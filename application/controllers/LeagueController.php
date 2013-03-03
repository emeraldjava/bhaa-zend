<?php
class LeagueController extends Zend_Controller_Action
{
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
    }
        
    public function indexAction()
    {
       	$this->_helper->redirector('list', 'league');
    }

    /**
     * List all leagues
     */
    public function listAction()
    {
        // action body
        $leagueTable = new Model_DbTable_League();

        $year = $this->_request->getParam('year',Zend_Date::now()->get(Zend_Date::YEAR));
        $this->view->year = $year;
        $this->view->years = $leagueTable->getDistinctYears();
        $this->view->leagues = $leagueTable->getLeaguesByYear($year);
    }

    public function summaryAction()
    {
        $year = $this->_request->getParam('year',Zend_Date::now()->get(Zend_Date::YEAR));
        $this->view->year = $year;
        //Zend_Debug::dump($year);
        
        $cache = Zend_Registry::get('cache');
        $dkey = sprintf("divisions");
        if(!$divisions = $cache->load($dkey))
        {
            $divisionTable = new Model_DbTable_Division();
            $divisions = $divisionTable->fetchAll();
            $cache->save($divisions,$dkey,array('divisions'));
        }
        $this->view->divisions = $divisions;

        $getDistinctYears = sprintf("getDistinctYears");
        if(!$years = $cache->load($getDistinctYears))
        {
            $leagueTable = new Model_DbTable_League();
            $years = $leagueTable->getDistinctYears();
            $cache->save($years,$getDistinctYears,array('distinctYears'));
        }
        $this->view->years = $years;

        $getLeaguesByYear = sprintf("getLeaguesByYear_%d",$year);
        if(!$leagues = $cache->load($getLeaguesByYear))
        {
            $leagueTable = new Model_DbTable_League();
            $leagues = $leagueTable->getLeaguesByYear($year);
            $cache->save($leagues, $getLeaguesByYear,array('leaguesByYear'.$year));
        }
        $this->view->leagues = $leagues;
        
        $getIndividualLeagueSummary = sprintf("%dGetIndividualLeagueSummary",$year);
        if(!$individualleaguesummary = $cache->load($getIndividualLeagueSummary))
        {
            $leagueRunnerData = new Model_DbTable_LeagueSummary();
            $individualleaguesummary = $leagueRunnerData->getIndividualLeagueSummary($year);
            $cache->save($individualleaguesummary,$getIndividualLeagueSummary,array('leaguesummaryInd'.$year));
        }
        //Zend_Debug::dump($individualleaguesummary);
        $this->view->individualleaguesummary = $individualleaguesummary;

        $getTeamLeagueSummary = sprintf("%dGetTeamLeagueSummary",$year);
        if(!$teamleaguesummary = $cache->load($getTeamLeagueSummary))
        {
            $leagueRunnerData = new Model_DbTable_LeagueSummary();
            $teamleaguesummary = $leagueRunnerData->getTeamLeagueSummary($year);
            $cache->save($teamleaguesummary,$getTeamLeagueSummary,array('leaguesummaryTeam'.$year));
        }
        $this->view->teamleaguesummary = $teamleaguesummary;
    }

    public function teamsAction()
    {
         $leagueid = $this->_request->getParam('league');
         $leagueTable = new Model_DbTable_League();
         $this->view->league = $leagueTable->getLeague($leagueid);
    }
    
    /**
     * The team leagues
     */
    public function teamAction()
    {
        $leagueid = $this->_request->getParam('league');
        $gender = $this->_request->getParam('gender');

        $leagueTable = new Model_DbTable_League();
        $this->view->league = $leagueTable->getLeague($leagueid);

        $letable = new Model_DbTable_LeagueEvent();
        $taggedraces = $letable->getLeagueTagsAndRaces($leagueid,$gender);
        $this->view->taggedraces = $taggedraces;

        $teamRaceResultTable = new Model_DbTable_TeamRaceResult();
        $this->view->teamleague = $teamRaceResultTable->getTeamLeague($taggedraces,$leagueid,$gender);
    }

    /**
     * The individual league and their divisions.
     */
    public function individualsAction()
    {
        $leagueid = $this->_request->getParam('league');
        
        $table = new Model_DbTable_League();
        $this->view->league = $table->getLeague($leagueid);
        
        $division = new Model_DbTable_Division();
		$this->view->divisions = $division->getIndividualDivisions();
    }
    
    /**
     * Individual league division query
     */
    public function individualAction()
    {
    	$logger = Zend_Registry::get('logger');    	
			
    	$leagueid = $this->_request->getParam('league');
    	$ltable = new Model_DbTable_League();
        $this->view->league = $ltable->getLeague($leagueid);
    	
    	$divisioncode = $this->_request->getParam('divisioncode');
    	$divisionTable = new Model_DbTable_Division();
        $division = $divisionTable->getDivisonByCode($divisioncode);
        $this->view->division = $division;

        $cache = Zend_Registry::get('cache');

        $leagueEventKey = sprintf("GetLeagueTagsAndRaces_%d_%s",$leagueid,$division->gender);
        if(!$races = $cache->load($leagueEventKey))
        {
            $logger->info(sprintf("get league table %d division %d",$leagueid,$division->max));
            $letable = new Model_DbTable_LeagueEvent();
            $races = $letable->getLeagueTagsAndRaces($leagueid,$division->gender);
            $cache->save($races,$leagueEventKey,array('leagueRaces'.$leagueid));
        }
        $this->view->events = $races;

        $individualleaguekey = sprintf("GetIndividualLeague_%d_%s",$leagueid,$division->code);
        if(!$leaguetable = $cache->load($individualleaguekey))
        {
            $table = new Model_DbTable_RaceResult();
            $leaguetable = $table->getIndividualLeague($leagueid,$division,$races);
            $cache->save($leaguetable,$individualleaguekey,array('league'.$leagueid));
        }
        $this->view->leaguetable = $leaguetable;
    }
    
    public function updateteamsAction()
    {
        $logger = Zend_Registry::get('logger');

        $leagueid = $this->_request->getParam('league');
        $raceid = $this->_request->getParam('race');
    	$logger->info(sprintf('-->updateteamsAction(%d,%d)',$leagueid,$raceid));

        if($leagueid==5)
        {
//            CALL addScoringMensTeams(5, 20108);
//            CALL updateScoringTeamTotals(20108);
//            CALL updateScoringTeamClasses(20108);
//            CALL updateScoringMensTeamPoints();

            $db = Zend_Db_Table::getDefaultAdapter();
            $sql = $db->prepare(sprintf("CALL addScoringMensTeams(%d,%d)",$leagueid,$raceid));
            $sql->execute();
                //$res = $sql->fetchAll();
                //$sql->closeCursor();
    //            $logger->info(sprintf('addScoringMensTeams(%d,%d)',$leagueid,$raceid));

            //$db = Zend_Db_Table::getDefaultAdapter();
            $sql1 = $db->prepare(sprintf("CALL updateScoringTeamTotals(%d)",$raceid));
            //$logger->info($sql1);
            $sql1->execute();
            //$res = $sql->fetchAll();
            $sql1->closeCursor();
            //$logger->info(sprintf('updateScoringTeamTotals(%d)',$raceid));

            //$db = Zend_Db_Table::getDefaultAdapter();
            $sql2 = $db->prepare(sprintf("CALL updateScoringTeamClasses(%d)",$raceid));
            $sql2->execute();
            //$res = $sql->fetchAll();
            $sql2->closeCursor();
            //$logger->info(sprintf('updateScoringTeamClasses(%d)',$raceid));

            //$db = Zend_Db_Table::getDefaultAdapter();
            $sql3 = $db->prepare(sprintf("CALL updateScoringMensTeamPoints()"));
            $sql3->execute();
            //$res = $sql->fetchAll();
            $sql3->closeCursor();
            $logger->info(sprintf('updateScoringMensTeamPoints()'));
        }
        else
        {
//            CALL addScoringLadiesTeams(6, 20107); #league,race
//            CALL updateScoringTeamTotals(20107); #league
//            CALL updateScoringTeamPoints('W'); #class

            $db = Zend_Db_Table::getDefaultAdapter();
            $sql = $db->prepare(sprintf("CALL addScoringLadiesTeams(%d,%d)",$leagueid,$raceid));
            $sql->execute();
            //$res = $sql->fetchAll();
            $sql->closeCursor();

            //$db = Zend_Db_Table::getDefaultAdapter();
            $sql = $db->prepare(sprintf("CALL updateScoringTeamTotals(%d)",$raceid));
            $sql->execute();
            //$res = $sql->fetchAll();
            $sql->closeCursor();

            //$db = Zend_Db_Table::getDefaultAdapter();
            $sql = $db->prepare(sprintf("CALL updateScoringTeamPoints('W')"));
            $sql->execute();
            //$res = $sql->fetchAll();
            $sql->closeCursor();

        }

        $db = Zend_Db_Table::getDefaultAdapter();
        $sql = $db->prepare("insert into teamraceresult select * from tmpteamraceresult");
        $sql->execute();
        $sql->closeCursor();

        $logger->info(sprintf('<--updateteamsAction(%d,%d)',$leagueid,$raceid));
        $this->_helper->redirector('index', 'league');
    }
}
?>