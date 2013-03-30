<?php
class DivisionController extends Zend_Controller_Action
{
    function init()
    {
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
    
    public function indexAction()
    {
        // action body
        $this->view->title = "divisions";
        $division = new Model_DbTable_Division();
		$this->view->divisions = $division->fetchAll();
    }
    
    public function tableAction()
    {
    	$min = $this->_request->getParam('min');
    	$max = $this->_request->getParam('max');
    	
    	$table = new Model_DbTable_LeagueRunnerData();

  		$this->view->min = $min;
  		$this->view->max = $max;
		$this->view->leaguerows = $table->leagueTable($min,$max);
    }
}
?>