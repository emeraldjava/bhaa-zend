<?php
class RacetecController extends Zend_Controller_Action
{
    function init()
    {
        $this->initView();
        $this->view->setEscape('stripslashes');
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->_helper->ajaxContext()->addActionContext('memberfilter','html')->initContext();
        $this->_helper->ajaxContext()->addActionContext('daymemberfilter','html')->initContext();
    }    
    
    public function indexAction()
    {
    	$this->_helper->redirector('member', 'racetec');
    }
        
    public function memberAction() {
    	$logger = Zend_Registry::get('logger');
    	$model = new Model_Racetec();
    	if ($this->getRequest()->isPost()) 
    	{
    		if($model->getForm()->isValid($this->getRequest()->getPost()))
    		{
    			$mergeddata = array();
    			foreach ($model->getForm()->getValues() as $subform) {
    				$mergeddata = array_merge($mergeddata, $subform);
    			}
    			$model->save($mergeddata);
    			$this->_helper->redirector('list', 'racetec');
    		}
    		else
    		{
    			$model->getForm()->populate($model->getForm()->getValues());
    		}
    	}
    	$this->view->model = $model;
    }
    
    public function dayAction()
    {
    	$logger = Zend_Registry::get('logger');
    	$model = new Model_Racetec();
    	$model->getForm()->getSubForm('raceSubForm')->getElement('type')->setValue('day');
    	$model->getForm()->getSubForm('runnerSubForm')->getElement('runner')->setValue('DAY');
    	$model->getForm()->getSubForm('runnerSubForm')->getElement('standard')->setValue('');   
    	$model->getForm()->getSubForm('runnerSubForm')->getElement('standard')->setAttrib('readonly','true');
    	$model->getForm()->getSubForm('runnerSubForm')->getElement('teamname')->setAttrib('readonly','true');
    	
    	if ($this->getRequest()->isPost()) 
    	{
    		$logger = Zend_Registry::get('logger');
    		if($model->getForm()->isValid($this->getRequest()->getPost()))
    		{
    			$data = array();
    			foreach ($model->getForm()->getValues() as $subform) {
    				$data = array_merge($data, $subform);
    			}
    			 
    			$dob = $data['dateofbirth'];
    			
    			$adapter = Zend_Db_Table::getDefaultAdapter();
    			$sql = sprintf('select getAgeCategory("%s","%s","%s",%d) as agecat',
    					$dob,Zend_Date::now()->toString("YYYY-MM-dd"),(string)$data['gender']=="M"?"M":"W",0);
    			
    			$stmt = $adapter->query($sql);
    			$result = $stmt->fetchObject();
    			$data['agecat']=$result->agecat;
    			
    			$model->save($data);
    			$this->_helper->redirector('list', 'racetec');
    		}
    		else
    		{
    			$model->getForm()->populate($model->getForm()->getValues());
    		}
    	}
    	$this->view->model = $model;
    }
        
    public function listAction()
    {
    	$model = new Model_Racetec();
    	$this->view->racetec = $model->fetchAll();
    }
    
    public function latestAction()
    {
    	$this->getResponse()->setHeader('Refresh', '15');
    	$model = new Model_Racetec();
    	$this->view->event =  $model->getEventCount();
    	//Zend_Debug::dump($model->getEventCount(),"",true);
    	$this->view->racetec = $model->fetchTop();
    }
    
    public function summaryAction()
    {
    	$model = new Model_Racetec();
    	$this->view->summary = $model->getSummary();
    	$this->view->racetec = $model->fetchAll();
    }
    
    public function exportAction()
    {
    	$this->_helper->layout->disableLayout();
    	$this->_helper->viewRenderer->setNeverRender();
    	
    	$eventTable = new Model_DbTable_Event();
    	$event = $eventTable->getNextEvent();
    	$fileName = $event->tag;
    	
    	$model = new Model_Racetec();
    	$rowsetArray = $model->fetchAll()->toArray();
    	$output = "";
    	$columns = $rowsetArray[0];
    	foreach ($columns as $column => $value) {
    		$output = stripslashes($output.$column.",");
    	}
    	$output = $output."\n";
    	
    	foreach ($rowsetArray as $rowArray) {
    		foreach ($rowArray as $column => $value) 
    		{
    			// string any comma's or the csv file is screwed.
    			$value = str_replace(",","",$value);
    			$value = html_entity_decode($value);
    			
    			switch ($column) {
    				case "runner":
    					if($value=="DAY")
							$output =  stripslashes($output.",");
						else
							$output =  stripslashes($output.$value.",");
						break;
					case "teamid":
						if($value=="0")
						$output =  stripslashes($output.",");
						else
						$output =  stripslashes($output.$value.",");
						break;
					case "companyid":
						if($value=="0")
						$output =  stripslashes($output.",");
						else
						$output =  stripslashes($output.$value.",");
						break;
    				default:
    					$output =  stripslashes($output.$value.",");
    			}
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
    
    public function memberfilterAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext())
    	{
    		$runnerTable = new Model_DbTable_Runner();
    		$this->view->runners = $runnerTable->searchActiveRunnersByFullNameOrID($this->_request->getParam('q'));
    	}
    }
    
    public function daymemberfilterAction()
    {
    	if ($this->_helper->ajaxContext()->getCurrentContext())
    	{
    		$runnerTable = new Model_DbTable_Runner();
    		$this->view->runners = $runnerTable->searchDayMembersByFullName($this->_request->getParam('q'));
    	}
    }
    
    public function adminAction()
    {
    	$logger = Zend_Registry::get('logger');
    	 
    	$config = new Zend_Config_Ini(APPLICATION_PATH.'/configs/grid.ini', 'production');
    	$db = Zend_Registry::get("db");
    	$grid = Bvb_Grid::factory('Table',$config,$id='');
    	
    	$grid->setSource(new Bvb_Grid_Source_Zend_Table(new Model_DbTable_Racetecs()));
    	
    	//CRUD Configuration
    	$form = new Bvb_Grid_Form();
    	$form->setAdd(false)->setEdit(true)->setDelete(true);
    	$form->setBulkDelete(true);
    	
    	$grid->setForm($form);
    	$grid->updateColumn('id',array('hidden'=>true));
    	$grid->updateColumn('address1',array('hidden'=>true));
    	$grid->updateColumn('address2',array('hidden'=>true));
    	$grid->updateColumn('address3',array('hidden'=>true));
    	$grid->updateColumn('newsletter',array('hidden'=>true));
    	$grid->updateColumn('mobile',array('hidden'=>true));
    	$grid->updateColumn('textmessage',array('hidden'=>true));
    	$grid->updateColumn('email',array('hidden'=>true));
    	$grid->updateColumn('teamid',array('hidden'=>true));
    	$grid->updateColumn('companyid',array('hidden'=>true));
    	$grid->updateColumn('type',array('hidden'=>false));
    	$grid->updateColumn('agecat',array('hidden'=>true));
    	
    	$grid->setExport(array());
    	$this->view->grid = $grid->deploy();
    }
    
    /**
    * id,runner,racenumber,event,firstname,surname,gender,dateofbirth,agecat,standard,address1,address2,address3,email,newsletter,mobile,textmessage,companyid,companyname,teamid,teamname,type,last_modified,
    1,5147,1,2_Mile,Edel,O'Connell,F,1972-12-27,W35,20,,,,,N,,N,117,Irish Life & Permanent,117,Irish Life & Permanent,member,2012-02-08 17:00:16,
    */
    public function racetecexportAction()
    {
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    	 
    	$this->_helper->layout->disableLayout();
    	$this->_helper->viewRenderer->setNeverRender();
    
    	$tag = $this->_request->getParam('tag');
    	
    	$eventTable = new Model_DbTable_Event();
    	$event = $eventTable->getEventByTag($tag);
    	 
    	$table = new Model_DbTable_RaceResult();
    	$results = $table->getRacetecExport($event->id);
    	 
    	$rowsetArray = $results->toArray();
    	 
    	$output = "";
    	$columns = $rowsetArray[0];
    	foreach ($columns as $column => $value) {
    		$output = stripslashes($output.$column.",");
    	}
    	$output = $output."\n";
    
    	foreach ($rowsetArray as $rowArray)
    	{
    		foreach ($rowArray as $column => $value)
    		{
    			// string any comma's or the csv file is screwed.
    			$value = str_replace(",","",$value);
    			$output =  stripslashes($output.$value.",");
    		}
    		$output = $output."\n";
    	}
    	header("Cache-Control: must-revalidate, post-check=0, pre-check=0");
    	header("Content-Length: ".strlen($output));
    	header("Content-type: text/x-csv");
    	header("Content-Disposition: attachment; filename=racetec_".$event->tag.".csv");
    	echo $output;
    	exit;
    }
}
?>