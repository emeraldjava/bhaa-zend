<?php
class TeamController extends Zend_Controller_Action
{
	function init()
    {
    	$this->_helper->ajaxContext()->addActionContext('teamfilter','html')->initContext();
        parent::init();
        
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();        
    }
        
    public function teamfilterAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext()) 
        {
        	$teamquery = $this->_request->getParam('q');
        	$table = new Model_DbTable_Team();
        	$this->view->teams = $table->searchForTeamsByName($teamquery);
        }
    }
    
    public function listAction()
    {
    	$teamTable = new Model_DbTable_Team();
    	$this->view->teams = $teamTable->getTeamsByStatus('ACTIVE');//fetchAll();
    }
    
    public function indexAction()
    {
    	$teamid = $this->_request->getParam('id', 0);
        $teamTable = new Model_DbTable_Team();
		$team = $teamTable->getTeam($teamid);
		$this->view->team = $team;
		
		$companyTable = new Model_DbTable_Company();
		$company = $companyTable->getCompany($team->parent);
		$this->view->company = $company;
		
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

        //$eventTable = new Model_DbTable_Event();
        //$eventTable->getPastEvents(5);

    }
    
    public function activeAction()
    {
	    $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
    	$teamid = $this->_request->getParam('id', 0);
        $teamTable = new Model_DbTable_Team();
        $updatedata = array('status' => 'ACTIVE');
		$teamTable->update($updatedata,"id = ".$teamid);
		
		$this->_helper->redirector('list', 'team');
    }

    public function addteammemberAction()
    {
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }

       	$teamid = $this->_request->getParam('id');
        $runnerid = $this->_request->getParam('runner');

        $logger = Zend_Registry::get('logger');
        //$logger->info($teamid.' '.$runnerid);

        $teamMemberTable = new Model_DbTable_TeamMember();
        $newmember = array(
            'team' => $teamid,
            'runner' => $runnerid,
            'joindate' => Zend_Date::now()->toString('y-M-d'));
		$teamMemberTable->insert($newmember);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','team', 'default',array('id'=>$teamid));
    }

    public function deleteAction()
    {
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }

       	$teamid = $this->_request->getParam('id');
        $runnerid = $this->_request->getParam('runner');

        $logger = Zend_Registry::get('logger');
        //$logger->info('delete '.$teamid.' '.$runnerid);

        $teamMemberTable = new Model_DbTable_TeamMember();
        $delete = array(
            'team' => $teamid,
            'runner' => $runnerid);
		$teamMemberTable->delete(sprintf("team=%d and runner=%d",$teamid,$runnerid));//$delete);

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','team', 'default',array('id'=>$teamid));
    }

    public function leaveAction()
    {
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }

       	$teamid = $this->_request->getParam('id');
        $runnerid = $this->_request->getParam('runner');

        $logger = Zend_Registry::get('logger');
        //$logger->info($teamid.' '.$runnerid);

        $teamMemberTable = new Model_DbTable_TeamMember();
        $delete = array(
            'leavedate' => Zend_Date::now()->toString('y-M-d'));
		$teamMemberTable->update($delete,sprintf("team=%d and runner=%d",$teamid,$runnerid));

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('index','team', 'default',array('id'=>$teamid));
    }

}
?>