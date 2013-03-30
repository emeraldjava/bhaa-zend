<?php
class SectorController extends Zend_Controller_Action
{
	
    function init()
    {
    	$this->_helper->ajaxContext()->addActionContext('sectorname','html')->initContext();
        parent::init();
        
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
    }
            
    public function listAction()
    {
        // action body
        $table = new Model_DbTable_Sector();
        $sectors = $table->listSectors();
        $this->view->sectors = $sectors;
    }
    
    function preDispatch()
    {
    	$this->_helper->authRedirector->saveRequestUri();
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    }
        
    public function sectornameAction()
    {
        if ($this->_helper->ajaxContext()->getCurrentContext()) 
        {
			$name = $this->_request->getParam('q');
        	$table = new Model_DbTable_Sector();
	       	$this->view->sectors = $table->searchSectorsByName($name);
        }
    }
    
    public function searchAction()
    {
    	$logger = Zend_Registry::get('logger');
    	
	    if ($this->getRequest()->isPost()) {
            $formData = $this->_request->getPost();

            $sector = $this->getRequest()->getPost('search');
            $this->view->title = sprintf("Search Sector %s",$sector);
            $logger->info(sprintf("Search Sector %s",$sector));
            $table = new Model_DbTable_Sector();
			//$stm = $table->select()->where("name like %A%");
            $like = $sector.'%';
			$this->view->sectors = $table->searchSectorsByName($like);
			
        }
        else
        {
        	return $this->_forward('index');
        }
    }
    
    public function indexAction()
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
    }
}
?>