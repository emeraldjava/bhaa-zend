<?php
class IndexController extends Zend_Controller_Action
{
    function init()
    {
    	$this->_helper->ajaxContext()->addActionContext('runnerfilter','html')->initContext();
    	$this->_helper->ajaxContext()->addActionContext('memberfilter','html')->initContext();
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
    
    public function runnerfilterAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext()) 
        {
    		$runnerTable = new Model_DbTable_Runner();
        	$this->view->runners = $runnerTable->searchActiveRunnersByName($this->_request->getParam('q'));
        }
    }
    
    public function memberfilterAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext())
    	{
    		$runnerTable = new Model_DbTable_Runner();
    		$this->view->runners = $runnerTable->searchActiveRunnersByName($this->_request->getParam('q'));
    	}
    }
	
    public function indexAction()
    {
        $this->view->title = "BHAA events";

	    $table = new Model_DbTable_Event();
		$this->view->event = $table->getMostRecentEvent();
		$this->view->events = $table->getUpcomingEvents(3);
		
		$companyTable = new Model_DbTable_Company();
		$this->view->logos = $companyTable->getRandomCompanyLogos(1);
    }

    public function homeAction()
    {
	    $table = new Model_DbTable_Event();
		$this->view->event = $table->getMostRecentEvent();
		$this->view->events = $table->getUpcomingEvents(1);
        $this->_helper->layout->disableLayout();
    }

    public function upcomingeventsAction()
    {
        $table = new Model_DbTable_Event();
		$this->view->events = $table->getUpcomingEvents(3);
        $this->_helper->layout->disableLayout();
    }

	public function sitemapAction()
    {
    	$this->view->layout()->disableLayout();
        $this->_helper->viewRenderer->setNoRender(true);
        echo $this->view->navigation()->sitemap();
    }
}
?>
