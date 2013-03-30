<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of BusinessController
 *
 * @author assure
 */
class HousesController extends Zend_Controller_Action
{

    function init()
    {
    	$this->_helper->ajaxContext()->addActionContext('housename','html')->initContext();
        parent::init();

        $this->initView();
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
    
    public function housenameAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext())
        {
            $query = $this->_request->getParam('q');
            $table = new Model_DbTable_Company();
            $this->view->companylist = $table->searchForCompaniesByName($query);
        }
    }

    public function indexAction()
    {
        $cache = Zend_Registry::get('cache');

        // sectors
        $sectorKey = sprintf("sectors");
        if(!$sectors = $cache->load($sectorKey))
        {
            $sectorTable = new Model_DbTable_Sector();
            $sectors = $sectorTable->listSectors();
            $cache->save($sectors,$sectorKey,array('sectors'));
        }
        $sectorCloud = new Zend_Tag_Cloud();
        foreach ($sectors as $sector) {
            $sectorCloud->appendTag(array(
                'title' => htmlspecialchars($sector['name']),
                'weight' => $sector['companies'],
                'params' => array('url' => $this->view->baseUrl.'/houses/sector/id/' . $sector['id'] )));
            }
        $sectorCloud->getCloudDecorator()->setHtmlTags(array('div'));
        $sectorCloud->getTagDecorator()
            ->setMinFontSize(10)//$options['min_font_size'])
            ->setMaxFontSize(25)//$options['max_font_size'])
            ->setHtmlTags(array('span'));
        $this->view->sectorCloud = $sectorCloud;

        // list random companies
        $companyKey = sprintf("companies");
        if(!$companies = $cache->load($companyKey))
        {
            $sectorTable = new Model_DbTable_Sector();
            $companies = $sectorTable->selectRandomCompanies(50);
            $cache->save($companies,$companyKey,array('companies'));
        }
        $companyCloud = new Zend_Tag_Cloud();
        foreach ($companies as $company) {
            $companyCloud->appendTag(array(
                'title' => htmlspecialchars($company['name']),
                'weight' => 1,
                'params' => array('url' => $this->view->baseUrl.'/houses/company/id/' . $company['id'] )));
            }
        $companyCloud->getCloudDecorator()->setHtmlTags(array('div'));
        $companyCloud->getTagDecorator()
            ->setMinFontSize(15)//$options['min_font_size'])
            ->setMaxFontSize(15)//$options['max_font_size'])
            ->setHtmlTags(array('span'));
        $this->view->companyCloud = $companyCloud;

        // teams
        $teamKey = sprintf("teams");
        if(!$teams = $cache->load($teamKey))
        {
            $teamTable = new Model_DbTable_Team();
            $teams = $teamTable->getTeamsByStatus('ACTIVE');
            $cache->save($teams,$teamKey,array('teams'));
        }
        $teamCloud = new Zend_Tag_Cloud();
        foreach ($teams as $team) {
            $cloudurl = '/houses/company/id/';
            if($team->type=="S")
                $cloudurl = '/houses/team/id/';
            $teamCloud->appendTag(array(
                'title' => htmlspecialchars($team['name']),
                'weight' => $team['runners'],
                'params' => array('url' => $this->view->baseUrl.$cloudurl.$team['id'] )));
            }
        $teamCloud->getCloudDecorator()->setHtmlTags(array('div'));
        $teamCloud->getTagDecorator()
            ->setMinFontSize(10)//$options['min_font_size'])
            ->setMaxFontSize(25)//$options['max_font_size'])
            ->setHtmlTags(array('span'));
        $this->view->teamCloud = $teamCloud;
    }
    
    public function listAction()
    {
    	$type = $this->_request->getParam('type','sector');
    	$this->view->type=$type;
    	if($type=='team')
    	{
	    	$teamTable = new Model_DbTable_Team();
	    	$this->view->teams = $teamTable->getTeamsByStatus('ACTIVE');
    	}
    	else if($type=='company')
    	{
    		$companyTable = new Model_DbTable_Company();
    		$letter = $this->_request->getParam('letter',null);
		    if($letter!=null)
		    {
				$this->view->letter = $letter;
		    	$this->view->companies = $companyTable->findCompaniesByFirstLetter($letter);
		    }
		    else 
		    	$this->view->companies = $companyTable->listCompaniesByFirstLetter();
    	}
    	else 
    	{
    		$sectorTable = new Model_DbTable_Sector();
	        $sectors = $sectorTable->listSectors();
	        $this->view->sectors = $sectors;
    	}
    }

    public function sectorAction()
    {
    	$sectorid = $this->_request->getParam('id', 0);

        $sectorTable = new Model_DbTable_Sector();
        $this->view->sector = $sectorTable->getSector($sectorid);

        $companyTable = new Model_DbTable_Company();
		$this->view->companies = $companyTable->getCompaniesBySector($sectorid);

        $teamTable = new Model_DbTable_Team();
		$this->view->teams = $teamTable->getTeamsBySector($sectorid);

        $runnerTable = new Model_DbTable_Runner();
        $this->view->runners = $runnerTable->getRunnersBySector($sectorid);

        $leageSummaryTable = new Model_DbTable_LeagueSummary();
        $this->view->indivSector = $leageSummaryTable->getIndividualLeagueSummayBySector($sectorid);
        $this->view->teamSector = $leageSummaryTable->getTeamLeagueSummaryBySector($sectorid);
    }

    public function companyAction()
    {
    	$companyid = $this->_request->getParam('id');

        $companyTable = new Model_DbTable_Company();
        $company = $companyTable->getCompany($companyid);
        $this->view->company = $company;

        $leagueSummaryTable = new Model_DbTable_LeagueSummary();
        $this->view->leaguesummary = $leagueSummaryTable->getSummary($companyid);
        
        $sectorTable = new Model_DbTable_Sector();
        $this->view->sector = $sectorTable->getSector($company->sector);

        $table = new Model_DbTable_Runner();
    	$this->view->runners = $table->getRunnersByCompany($companyid);

    	$leagueTable = new Model_DbTable_League();
    	$league = $leagueTable->getCurrentLeague("I");
    	
        $leagueSummaryTable = new Model_DbTable_LeagueSummary();
        $this->view->indivLeague = $leagueSummaryTable->getIndividualLeagueByCompany($companyid,$league->id);
        
        $teamRaceResultsTable = new Model_DbTable_TeamRaceResult();
		$teamresults = $teamRaceResultsTable->getResultsForTeam($companyid);
        $this->view->teamresults = $teamresults;
    }

    public function teamAction()
    {
        $teamid = $this->_request->getParam('id', 0);
        $teamTable = new Model_DbTable_Team();
        $team = $teamTable->getTeam($teamid);
        $this->view->team = $team;
//
//		$companyTable = new Model_DbTable_Company();
//		$company = $companyTable->getCompany($team->parent);
//		$this->view->company = $company;

        $leagueSummaryTable = new Model_DbTable_LeagueSummary();
        $this->view->leaguesummary = $leagueSummaryTable->getSummary($teamid);

        $sectorTable = new Model_DbTable_Sector();
        if($team->type=='C')
            $this->view->sector = $sectorTable->getSector($company->sector);
            else
            $this->view->sector = $sectorTable->getSector($team->parent);

        $teamMemberTable = new Model_DbTable_TeamMember();
        $teamdetails = $teamMemberTable->getRunnerDetailsForTeam($teamid);
        $this->view->members = $teamdetails;

        $teamRaceResultsTable = new Model_DbTable_TeamRaceResult();
        $teamresults = $teamRaceResultsTable->getResultsForTeam($teamid);
        $this->view->teamresults = $teamresults;

        $leagueSummaryTable = new Model_DbTable_LeagueSummary();
        $this->view->indivLeague = $leagueSummaryTable->getIndividualLeagueByTeam($teamid);
    }
}
?>