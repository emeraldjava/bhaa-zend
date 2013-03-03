<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
require_once 'Excel/Excel_Reader.php';
/**
 * Description of RunirelandController
 * 
 * @author assure
 */
class RunirelandController extends Zend_Controller_Action {

    var $logger;
    
    function init()
    {
        parent::init();
        $this->logger = Zend_Registry::get('logger');

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
        $this->view->title = "Runireland";
        
        $eventTable = new Model_DbTable_Event();
        $this->view->event = $eventTable->getNextEvent();
        
        $runirelandTable = new Model_DbTable_Runireland();
        $this->view->runireland = $runirelandTable->export($this->view->event);
    }
    
    public function importAction()
    {
    	$this->view->title = "Runireland";
    	
    	$model = new Model_Runireland();
    	if ($this->getRequest()->isPost()) 
    	{
    		$csvdetails = $this->getRequest()->getPost("csvdetails");
    		
    		$rows = explode("\n", $csvdetails);
    		//$rows = $this->csvstring_to_array($csvdetails,"\n","","\n");//str_getcsv($csvdetails, "\n"); //parse the rows
    		foreach($rows as &$row) 
    		{
    			//$this->logger->info(sprintf($row));
    			//$row = $this->csvstring_to_array($row,",","","\n");//$str_getcsv($row, ","); //parse the items in rows
    			$fields = explode(",", $row);
    			$model->insertRunnerDetails($fields);
    		}	
    		$this->_helper->redirector('index', 'runireland');
    	}
    }   
        
	public function exportAction()
    {
        $logger = Zend_Registry::get('logger');

        $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNeverRender();

        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getNextEvent();

        $fileName = sprintf("%s_runireland",$event->tag);
        $logger->info(sprintf('start exportAction(%s)',$fileName));

        $runnerTable = new Model_DbTable_Runireland();
        $rowset = $runnerTable->export($event);
        $rowsetArray = $rowset->toArray();

		$output = "";
		$columns = $rowsetArray[1];
		foreach ($columns as $column => $value) {
			$output = $output.$column.",";
		}
		$output = $output."\n";

		foreach ($rowsetArray as $rowArray) {
		    foreach ($rowArray as $column => $value) {
		    	$output =  stripslashes($output.$value.",");
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
}
?>