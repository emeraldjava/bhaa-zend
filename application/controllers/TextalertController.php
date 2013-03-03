<?php
require_once 'Text.php';

class TextalertController extends Zend_Controller_Action
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
    	$logger = Zend_Registry::get('logger');
    	$logger->info(sprintf('-->indexAction'));
        $mobileTable = new Model_DbTable_MobileAccount();
		$this->view->mobiles = $mobileTable->getAllMobileAccounts();
		$logger->info(sprintf('<--indexAction'));
    }
    
    public function preparetextAction()
    {
    	$account = $this->_request->getParam('account');
    	$logger = Zend_Registry::get('logger');
    	$logger->info(sprintf('preparetextAction(%d)',$account));
    	
    	$mobileTable = new Model_DbTable_MobileAccount();
		$mobile = $mobileTable->getMobileAccount($account);
		$logger->info(sprintf('preparetextAction(%s)',$mobile->name));
		$this->view->mobile = $mobile;
		
		$listTable = new Model_DbTable_Textalert();
		$this->view->mobiles = $listTable->getMobilesLinkedToPhone($mobile->id);
    }
    
    public function sendtextAction()
    {
    	$logger = Zend_Registry::get('logger');
    	$logger->info(sprintf('sendtextAction()'));
    	
    	$formData = $this->_request->getPost();
    	//Zend_Debug::dump($formData,"formdata",true);
    	$logger->info(sprintf('form %s',$formData));
    	$name = $formData['name'];
		$message = $formData['message'];
   		$logger->info(sprintf('account %s message %s',$name,$message));

   		$mobileTable = new Model_DbTable_MobileAccount();
		$mobile = $mobileTable->getMobileAccountByName($name);
		$logger->info(sprintf('send from account number %s',$mobile->number));
		
		$listTable = new Model_DbTable_Textalert();
		$targets = $listTable->getMobilesLinkedToPhone($mobile->number);
		
		$selectedmobiles = array_values($_POST['selectedmobiles']);
		$logger->info(sprintf('$selectedmobiles %s',$selectedmobiles));

		$targets = $_POST['selectedmobiles'];
		$this->sendtext($mobile->number,$mobile->password,$message,$targets);
		$this->_helper->redirector('index', 'textalert');
    }
    
	function sendtext($number,$password,$message,$targets)
    {
    	$logger = Zend_Registry::get('logger');

        $textclass = new Text($logger);
    	
    	$logger->info(sprintf('login into %s %s',$number,$password));
    	
    	$ret=$textclass->login($number,$password);
			
		if ($ret==-1 || $ret==-2)	//invalid login or failed to connect
		{
			//$logger->info(sprintf("invalid login"));
			//$textclass->delCookie();
			return -1;
		}
		else
		{
			//$logger->info(sprintf("logged in"));
			$ret=$textclass->goto_text_page();
            $logger->info("goto_text_page "+$ret);
            //$logger->info(sprintf("Number %s has %d messages remaining.",$number,$textclass->messagesleft));
			
			foreach($targets as $target)
			{
				$ret=$textclass->send_message($target,$message);
				$logger->info(sprintf("message sent %d",$ret));
			}
			
			$textclass->delCookie();
			//return $textclass->messagesleft;
		}
    }
    
    public function remainingmessagesAction()
    {
    	$logger = Zend_Registry::get('logger');
    	$logger->info(sprintf('check remaining messages'));
    	
    	$mobileTable = new Model_DbTable_MobileAccount();
		$mobiles = $mobileTable->fetchAll();
		//$logger->info(sprintf('%d',sizeof($mobiles)));
		foreach($mobiles as $mobile)
		{
			$remaining = $this->checkRemainingMessages($mobile->number,$mobile->password);			
			$logger->info(sprintf('remaining texts for account %d %s %s %d',$mobile->id,$mobile->name,$mobile->number,$remaining));
			
			if($remaining != -1 && $remaining != $mobile->remainingtexts)
			{
				$logger->info(sprintf('update DB %d %s %s %d',$mobile->id,$mobile->name,$mobile->number,$remaining));
				$data = array('remainingtexts'=>$remaining);
				
				try
				{

					$mobileTable2 = new Model_DbTable_MobileAccount();
					$mobileTable2->getDefaultAdapter()->getProfiler()->setEnabled(true);
					$updated = $mobileTable2->update($data,sprintf("id = %d",$mobile->id));
					$logger->info(sprintf("%s",$mobileTable2->getDefaultAdapter()->getProfiler()->getLastQueryProfile()->getQuery()));
					//$logger->info(sprintf("%s",$mobileTable2->getDefaultAdapter()->getProfiler()->getLastQueryProfile()->getQueryParams()));
					$mobileTable2->getDefaultAdapter()->getProfiler()->setEnabled(false);
					$logger->info(sprintf('No of DB rows updated %d',$updated));
				
				} catch (Exception $e) {
					$logger->info(sprintf('%s',$e->getMessage()));
				}
			}
		}
		$this->_helper->redirector('index', 'textalert');
    }
    
	function checkRemainingMessages($number,$password)
    {
    	$logger = Zend_Registry::get('logger');
        $textclass = new Text($logger);
    	$logger->info(sprintf('login into %s %s',$number,$password));
    	
    	$ret=$textclass->login($number,$password);
			
		if ($ret==-1 || $ret==-2)	//invalid login or failed to connect
		{
			$logger->info(sprintf("invalid login"));
			$textclass->delCookie();
			return -1;
		}
		else
		{
			$logger->info(sprintf("logged in"));
			$ret=$textclass->goto_text_page();
			$logger->info(sprintf("Number %s has %d messages remaining.",$number,$textclass->messagesleft));
			$textclass->delCookie();
			return $textclass->messagesleft;
		}
    }

    public function checkremainingAction()
    {
    	$logger = Zend_Registry::get('logger');
    	$logger->info(sprintf('check remaining messages'));

        $mobileid = $this->_request->getParam('account', 0);
    	$mobileTable = new Model_DbTable_MobileAccount();
		$mobile = $mobileTable->getMobileAccount($mobileid);
		$this->view->mobile = $mobile;

        $remaining = $this->checkRemainingMessages($mobile->number,$mobile->password);
        $logger->info(sprintf('remaining texts for account %d %s %s %d',$mobile->id,$mobile->name,$mobile->number,$remaining));

        if($remaining != -1 && $remaining != $mobile->remainingtexts)
        {
            $logger->info(sprintf('update DB %d %s %s %d',$mobile->id,$mobile->name,$mobile->number,$remaining));
            $data = array('remainingtexts'=>$remaining);

            try
            {
                $updated = $mobileTable->update($data,sprintf("id = %d",$mobile->id));
                $logger->info(sprintf('No of DB rows updated %d',$updated));

            } catch (Exception $e) {
                $logger->info(sprintf('%s',$e->getMessage()));
            }
        }
		$this->_helper->redirector('index', 'textalert');
    }
    
    public function exportAction()
    {
        $logger = Zend_Registry::get('logger');

        $mobileaccount = $this->_request->getParam('account', 0);
        $filename = 'bhaa_textalerts.csv';
        if($mobileaccount != 0)
        {
        	$mobileTable = new Model_DbTable_MobileAccount();
			$mobile = $mobileTable->getMobileAccount($mobileaccount);
        	$filename = $mobile->username.'_textalerts.csv';
        }     
		
        $this->_helper->layout->disableLayout();
	    $this->_helper->viewRenderer->setNeverRender();

        $textalertTable = new Model_DbTable_Textalert();
        $rowset = $textalertTable->exportTextAlertDetails($mobileaccount);
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
		header("Content-Length: ".strlen($output));
		header("Content-type: text/x-csv");
		header("Content-Disposition: attachment; filename=".$filename);

		echo $output;
		exit;
    }
    
    public function addtotextlistAction()
    {
    	$runner = $this->_request->getParam('id');
    	// call AddRunnerToMobileAccount(5738);
    	$db = Zend_Db_Table::getDefaultAdapter();
        $sql = $db->prepare(sprintf("CALL AddRunnerToMobileAccount(%d)",$runner));
        $sql->execute();
        $sql->closeCursor();
        $logger = Zend_Registry::get('logger');
        $logger->info(sprintf("CALL AddRunnerToMobileAccount(%d)",$runner));
		$this->getHelper('Redirector')->gotoSimple('index','runner',null,array('id' => $runner));
    }
    
    public function removefromtextlistAction()
    {
    	$runner = $this->_request->getParam('runner');
    	$account = $this->_request->getParam('account');
    	// call AddRunnerToMobileAccount(5738);
    	$textAlertTable = new Model_DbTable_Textalert();
    	$textAlertTable->disableTextAlert($runner);
		$this->getHelper('Redirector')->gotoSimple('preparetext','textalert',null,array('account'=>$account));
    }
}
?>