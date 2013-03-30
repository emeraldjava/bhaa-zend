<?php
class RegistrationController extends Zend_Controller_Action
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
        
    public function listregisteredrunnersAction()
    {
    	$event = $this->_request->getParam('event');
    	$eventTable = new Model_DbTable_Event();
		$this->view->event = $eventTable->getEvent($event);

    	$table = new Model_DbTable_Registration();
    	$this->view->registered = $table->listRegisteredRunnersByEvent($event);
    }
    
    // http://zendgeek.blogspot.com/2009/07/sending-email-with-attachment-in-zend.html
    public function preregistrationAction()
    {
        $metaTable = new Model_DbTable_Metadata();
        $enabled = $metaTable->getMetadata(
            Model_DbTable_Metadata::TYPE_ADMIN,
            0,
            Model_DbTable_Metadata::MEMBERSHIP_FORM);

        if(isset($enabled->value) && ($enabled->value == Model_DbTable_Metadata::DISABLED) )
            $this->_helper->redirector('suspended','membership');

    	$form = new Form_PreRegistrationForm();
        $logger = Zend_Registry::get('logger');
                
	    if ($this->_request->isPost()) {

            $formData = $this->_request->getPost();
    		$logger->info(sprintf('preregistration() %d',$formData['eventid']));
            
            $eventTable = new Model_DbTable_Event();
            $event = $eventTable->getEvent($formData['eventid']);
        
            $this->view->event = $event;
    		
	    	if($form->isValid($formData))
			{
	    		$table = new Model_DbTable_Registration();
	    		$dob = new Zend_Date($formData['dateofbirth']);
                $now = Zend_Date::now()->getIso();
	    		$logger->info("preregistration() form ".$uploadedData['dateofbirth']." ".$now);
                
		        $mappeddata = array(
		        	'eventid' => $formData['eventid'],
		            'firstname' => stripslashes($formData['firstname']),
		            'surname' => stripslashes($formData['surname']),
		        	'gender' => $formData['gender'],
		            'dateofbirth' => $dob->toString("YYYY-MM-dd"),
                    'company' => $formData['company'],
                    'companyname' => $formData['companyname'],
		        	'address1' => $formData['address1'],
		            'address2' => $formData['address2'],
		            'address3' => $formData['address3'],
		            'email' => $formData['email'],
		            'mobile' => $formData['mobile'],
                    'newsletter' => $formData['newsletter'],
			        'textmessage' => $formData['textmessage'],
	            	'insertdate' => Zend_Date::now()->toString("YYYY-MM-dd")
		        );
	    		$table->insert($mappeddata);
        		$logger->info("insert to table");

                $SEND_MAIL = true;
                if($SEND_MAIL)
                {
			    // do whatever you need to do
                    $config = array('auth' => 'login',
                        'username' => 'registrar@bhaa.ie',
                        'password' => 'Passw0rd10',
                        'ssl' => 'tls',
                        'port' => 587);
                    $transport = new Zend_Mail_Transport_Smtp('smtp.gmail.com', $config);
				Zend_Mail::setDefaultTransport($transport);
				$mail = new Zend_Mail();

                                $mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
				$mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');
				$mail->addTo($formData['email']);
				$mail->setSubject(sprintf('%s %s : BHAA %s Race - Day Member Registration Form',
                                        stripslashes($formData['firstname']),
                                        stripslashes($formData['surname']),
                                        $event->name));

				$myView = new Zend_View();
				$this->view->form = $form;
				$myView->firstname = $formData['firstname'];
				$myView->surname = $formData['surname'];
				$myView->gender = $formData['gender'];
				$myView->dateofbirth = $formData['dateofbirth'];
				$myView->address1 = $formData['address1'];
				$myView->address2 = $formData['address2'];
				$myView->address3 = $formData['address3'];
				$myView->email = $formData['email'];
				$myView->mobile = $formData['mobile'];
                $myView->companyname = $formData['companyname'];
		        $myView->newsletter = $formData['newsletter'];
		        $myView->textmessage = $formData['textmessage'];
				$myView->event = $event;
				$myView->addScriptPath(APPLICATION_PATH . '/views/scripts/registration');
				$html_body = $myView->render('preregistrationemail.phtml');

				$mail->setType(Zend_Mime::MULTIPART_RELATED);
				$mail->setBodyHtml($html_body);
	        	$mail->send($transport);
	        	
	        	return $this->_forward('confirmdaymember');
                }
                else
                {
                    $this->view->firstname = $formData['firstname'];
                    $this->view->surname = $formData['surname'];
                    $this->view->gender = $formData['gender'];
                    $this->view->dateofbirth = $formData['dateofbirth'];
                    $this->view->address1 = $formData['address1'];
                    $this->view->address2 = $formData['address2'];
                    $this->view->address3 = $formData['address3'];
                    $this->view->email = $formData['email'];
                    $this->view->mobile = $formData['mobile'];
                    $this->view->companyname = $formData['companyname'];
    		        $this->view->newsletter = $formData['newsletter'];
        	        $this->view->textmessage = $formData['textmessage'];
                    $this->view->event = $event;
                    return $this->_forward('confirmdaymember');
                }
	    	} 
		    else 
		    {
		    	$form->populate($formData);
   	    		$logger->info("Errors:".$form->getMessages());
		        $this->view->errors = $form->getMessages();
		    }
		}
        else
        {
            $eventTable = new Model_DbTable_Event();
            $tag = $this->_request->getParam('tag');
            $event = $eventTable->getEventByTag($tag);
            $this->view->event = $event;
            $form->eventid->setValue($event->id);
        }
        $this->view->form = $form;
    }

    public function confirmdaymemberAction()
    {}
}
?>