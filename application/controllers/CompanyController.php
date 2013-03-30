<?php
class CompanyController extends Zend_Controller_Action
{
    function init()
    {
    	$this->_helper->ajaxContext()->addActionContext('companyname','html')->initContext();
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
    
    public function companynameAction()
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
    	$id = $this->_request->getParam('id', 0);
        
        $companyTable = new Model_DbTable_Company();
        $company = $companyTable->getCompany($id);
        $this->view->company = $company;
        
        $sectorTable = new Model_DbTable_Sector();
        $this->view->sector = $sectorTable->getSector($company->sector);
        
        $table = new Model_DbTable_Runner();
        $this->view->runners = $table->getRunnersByCompany($id);
    }
    
    public function addAction()
    {
	    $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
        $form = new Form_CompanyForm();
        $logger = Zend_Registry::get('logger');
        
    	if ($this->_request->isPost()) {

	        $formData = $this->_request->getPost();
			if($form->isValid($formData))
			{
	    		$table = new Model_DbTable_Company();
	            $mappeddata = array(
			        'id' => $formData['id'],
		            'name' => stripslashes($formData['name']),
		            'sector' => stripslashes($formData['sector']),
		            'website' => $formData['website'],
		        	'image' => $formData['image']
		        );
	    		$table->insert($mappeddata);

                $redirector = $this->_helper->getHelper('redirector');
                $redirector->gotoSimpleAndExit('index','company', 'default',
                    array('id'=>$formData['id']));
	    	} 
		    else 
		    {
		    	$form->populate($form->getValues());
   	    		$logger->info("Errors:".$form->getMessages());
		        $this->view->errors = $form->getMessages();
		    }
		}
        else
        {
            $name = $this->_request->getParam('name','');
            $table = new Model_DbTable_Company();
            $row = $table->getNewCompanyId();
            $form->id->setValue($row->nextcompanyid);
            $form->name->setValue($name);
        }
        $this->view->form = $form;
    }
    
    public function editAction()
    {
	    $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        $form = new Form_CompanyForm();
        
    	if ($this->_request->isPost()) {

	        $formData = $this->_request->getPost();
			if($form->isValid($formData))
			{
	    		$table = new Model_DbTable_Company();
	            $mappeddata = array(
			        //'id' => $formData['id'],
		            'name' => stripslashes($formData['name']),
		            'sector' => stripslashes($formData['sector']),
		            'website' => $formData['website'],
		        	'image' => $formData['image']
		        );
	    		$table->update($mappeddata,"id = ".$formData['id']);
                $redirector = $this->_helper->getHelper('redirector');
                $redirector->gotoSimpleAndExit('index','company', 'default',
                    array('id'=>$formData['id']));
	    	} 
		    else 
		    {
		    	$form->populate($form->getValues());
   	    		$logger->info("Errors:".$form->getMessages());
		        $this->view->errors = $form->getMessages();
		    }
		}
		else
		{
			$id = $this->_request->getParam('id');
        	$table = new Model_DbTable_Company();
        	$company = $table->getCompany($id);
        	$mappeddata = array(
			        'id' => $company->id,
		            'name' => $company->name,
		            'sector' => $company->sector,
		            'website' => $company->website,
		        	'image' => $company->image
		        );
        	$form->populate($mappeddata);
		}
        $this->view->form = $form;
    }

    public function deleteAction()
    {
        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }

        $id = $this->_request->getParam('id', 0);

        $companyTable = new Model_DbTable_Company();
        $companyTable->delete(sprintf('id=%d',$id));

        $this->_helper->redirector('list', 'company');
    }
    
    public function listAction()
    {
    	$table = new Model_DbTable_Company();
    	$this->view->companies = $table->listCompaniesByFirstLetter();
    }
    
    public function listbyletterAction()
    {
    	$letter = $this->_request->getParam('letter');
    	$table = new Model_DbTable_Company();
    	$this->view->companies = $table->findCompaniesByFirstLetter($letter);
    }
    
    public function listrunnersAction()
    {
    	$companyid = $this->_request->getParam('company');
        
        $companyTable = new Model_DbTable_Company();
        $company = $companyTable->getCompany($companyid);
        $this->view->company = $company;
        
        $sectorTable = new Model_DbTable_Sector();
        $this->view->sector = $sectorTable->getSector($company->sector);
        
        $table = new Model_DbTable_Runner();
        $this->view->runners = $table->getRunnersByCompany($companyid);
    }

    //insert into
    //teamraceresult(team,league,race,class,leaguepoints)
    //values
    //(144,5,201036,'O',7);
    public function addraceorganiserpointsAction()
    {
        $logger = Zend_Registry::get('logger');
        $id = $this->_request->getParam('id');

        $eventTable = new Model_DbTable_Event();
        $currentEvent = $eventTable->getMostRecentEvent();

        $leagueTable = new Model_DbTable_League();
        $currentLeague = $leagueTable->getCurrentLeague();
    	$logger->info(sprintf('addraceorganiserpointsAction(%d,%d,%d,%s,%d)',$id,$currentLeague->id,$currentEvent->id,"O",7));

        $teamRaceResultTable = new Model_DbTable_TeamRaceResult();
        $teamRaceResultTable->insert(array(
            'team'=>$id,
            'league'=>$currentLeague->id,
            'race'=>$currentEvent->mensrace,
            'class'=>"O",
            'leaguepoints'=>7));

        $redirector = $this->_helper->getHelper('redirector');
        $redirector->gotoSimpleAndExit('company','houses', 'default',array('id'=>$id));
    }
}
?>