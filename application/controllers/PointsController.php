<?php

class PointsController extends Zend_Controller_Action
{
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
        $raceTable = new Model_DbTable_Race();
        $this->view->events = $raceTable->getAdminRaceDetails(20);
    }
    
	public function pointsAction()
    {
    	$race = $this->_request->getParam('id');
    	$pointsTable = new Model_DbTable_RacePoints();
    	$this->view->points = $pointsTable->getPointsForRace($race);
    	$this->view->runners = $pointsTable->runnersPerStandardAtRace($race,"M");
		$this->view->scoringsets = $pointsTable->scoringSetsPerStandardAtRace($race,"M");
		
    	$this->view->wrunners = $pointsTable->runnersPerStandardAtRace($race,"W");
		$this->view->wscoringsets = $pointsTable->scoringSetsPerStandardAtRace($race,"W");
    }
}
?>