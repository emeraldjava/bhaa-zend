<?php
include 'Runner.php';
include 'RaceResult.php';

class RaceController extends Zend_Controller_Action
{
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
    }
    
    public function indexAction()
    {
 	    $this->view->title = "Races";	
		$race = new Model_DbTable_Race();
		$this->view->races = $race->fetchAll();
    }

    function preDispatch()
    {
    	$this->_helper->authRedirector->saveRequestUri();
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    }
    
    public function resultsAction()
    {
        $raceid = $this->_request->getParam('race',0);
		
        $racetable = new Model_DbTable_Race();
        $race = $racetable->getRace($raceid);
        $this->view->race = $race;
        
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEvent($race->event);
        $this->view->event = $event;
                
        $table = new Model_DbTable_RaceResult();
        $this->view->results = $table->getRaceResults($raceid);
        
        $this->view->standards = $table->getStandardsBreakdown($raceid);
    }
    
    public function teamsAction()
    {
        $id = $this->_request->getParam('race', 0);
		
        $racetable = new Model_DbTable_Race();
        $race = $racetable->getRace($id);
        $this->view->race = $race;
        
        $eventTable = new Model_DbTable_Event();
        $event = $eventTable->getEvent($race->event);
        $this->view->event = $event;
                
        $table = new Model_DbTable_TeamRaceResult();
        $this->view->results = $table->getTeamResults($id);
    }
    
    public function deleteresultsAction()
    {
        $id = $this->_request->getParam('id', 0);
        $table = new Model_DbTable_Raceresult();
        $table->deleteRaceResults($id);
    }
    
    public function loadresultsAction()
    {
        $id = $this->_request->getParam('id', 0);
        
        $table = new Model_DbTable_Race();
        $race = $table->getRace($id);
        
        $this->loadFile($race);
        $this->view->race = $race;
    }
    
    private function loadFile($race)
    {
    	//printf($race->file."\n");
    	$handle = fopen($race->file, "r");
		//printf($handle."\n");
    	$count = 102000;    
		$race=$race->id;
		printf("loading results for $race->file with id $race->id");
		
		while (($data = fgetcsv($handle, 1000, ",")) !== FALSE) {
			$num = count($data);
			
		    // Place,Race No,Member No,Time,Surname,Name,S,Std,DOB,Grade,Company,Company No,,Age,Grade Check,CTRL g to Check Grade,
		    $position = $data[0];
		    $raceNumber = $data[1];
		    $member = $data[2];
		    $time = $data[3];
		    $surname = addslashes(trim($data[4]));
		    $firstname = addslashes(trim($data[5]));
		    if($data[6] == "L" )
		        $gender = "F";
		    	else
		        $gender = "M";
		    $standard = $data[7];
			if(strlen($standard)==0)
		    {
		        $standard=null;
		    }
		    $dateofbirth = $data[8];
			if(strlen($dateofbirth)==0)
		    {
		        $dateofbirth='29/02/1980';
		    }
		    $category = $data[9];
		    $company = addslashes(trim($data[10]));
		    $companyNumber = $data[11];
		    if(strlen($companyNumber)==0)
		    {
		        $companyNumber=null;
		    }
		    
		    if(strlen($member)==0)
		    {
		        $member=$count;
		        $count++;
		    }
		    
			$runner = new Runner($member,$firstname,$surname,$gender,$dateofbirth,$companyNumber,$standard);
		    $runner->save();
			//printf("".$runner->save());
		    
		    $raceResult = new RaceResult($race,$member,$time,$position,$raceNumber,$standard,$runner->getAgeCategory());
		    printf($raceResult->save()."<br/>");
		    
		    $resultTable = new Model_DbTable_Raceresult();
        	$resultRow = $resultTable->insert($raceResult->toArray());
        	printf($resultRow);
		}
		fclose($handle);
    }
}
?>