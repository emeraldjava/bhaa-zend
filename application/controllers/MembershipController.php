<?php
class MembershipController extends Zend_Controller_Action
{
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
        $this->view->user = Zend_Auth::getInstance()->getIdentity();
    }
    
    public function indexAction()
    {
    	$this->_helper->redirector('form','membership');
    }
    
    function preDispatch()
    {
    	$this->_helper->authRedirector->saveRequestUri();
    	$auth = Zend_Auth::getInstance();
    	if (!$auth->hasIdentity()) {
    		$this->_redirect('auth/login');
    	}
    }

    public function suspendedAction()
    {
    }
        
    // http://zendgeek.blogspot.com/2009/07/sending-email-with-attachment-in-zend.html
    public function formAction()
    {
        $metaTable = new Model_DbTable_Metadata();
        $enabled = $metaTable->getMetadata(
            Model_DbTable_Metadata::TYPE_ADMIN,
            0,
            Model_DbTable_Metadata::MEMBERSHIP_FORM);
        
        if(isset($enabled->value) && ($enabled->value == Model_DbTable_Metadata::DISABLED) )
            $this->_helper->redirector('suspended','membership');

        $logger = Zend_Registry::get('logger');
    	$tag = $this->_request->getParam('tag','bhaa2012');
    	$logger->info("tag ".$type.' '.$tag);
		$this->view->tag = $tag; 
			    
		$model = new Model_NewMember();
        if ($this->getRequest()->isPost()) {

	        $formData = $this->_request->getPost();
	        
	        $tag = $this->getRequest()->getPost('tag');
    	
    		$logger->info(sprintf('firstname %s',$formData['firstname']));
    		$logger->info(sprintf('companyname %s',$formData['companyname']));
			$logger->info(sprintf('email %s',$formData['email']));
			$logger->info(sprintf('tag %s %s',$formData['tag'],$tag));
    		$logger->info('isValid '.$model->getForm()->isValid($formData));
    		
			if($model->getForm()->isValid($formData))
			{
                $newmember = $model->save($formData,$tag);
                $now = Zend_Date::now()->getIso();
                $date = new Zend_Date($formData['dateofbirth']);

                $SEND_MAIL = true;
                if($SEND_MAIL)
                {
                	$config = Zend_Registry::get('config');
                    // do whatever you need to do
                    $emailconfig = array(
                    	'auth' => $config->email->auth,
                        'username' => $config->email->username,
                        'password' => $config->email->password,
                        'ssl' => $config->email->ssl,
                        'port' => (int)$config->email->port);
                    $transport = new Zend_Mail_Transport_Smtp($config->email->smtp, $emailconfig);
                    Zend_Mail::setDefaultTransport($transport);
                    $mail = new Zend_Mail();

                    $mail->addTo($formData['email']);
                    $mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
                    $mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');

                    $subject;
                    if($tag=="bhaa2012")
                    {
                    	$subject = sprintf('BHAA Membership Form 2012 : %s %s',
                        	stripslashes($formData['firstname']),
                        	stripslashes($formData['surname']));
                    	$mail->setSubject($subject);
                    }
                    else
                    {
						$eventTable = new Model_DbTable_Event();
			            $event = $eventTable->getEventByTag($tag);
			            $subject = sprintf('%s %s : BHAA Day Membership %s',
                            stripslashes($formData['firstname']),
                            stripslashes($formData['surname']),
                            $event->name);
                    	$mail->setSubject($subject);
                    }
                    $this->view->form = $form;
                    
                    $myView = new Zend_View();
                    $myView->subject = $subject;
                    $myView->firstname = $formData['firstname'];
                    $myView->surname = stripslashes($formData['surname']);
                    $myView->gender = $formData['gender'];
                    $myView->dateofbirth = $date->toString("dd/MM/YYYY");
                    $myView->address1 = $formData['address1'];
                    $myView->address2 = $formData['address2'];
                    $myView->address3 = $formData['address3'];
                    $myView->email = $formData['email'];
                    $myView->mobile = $formData['mobile'];
                    $myView->sectorname = $formData['sectorname'];
                    $myView->companyname = $formData['companyname'];
                    $myView->company = $formData['company'];
                    $myView->newsletter = $formData['newsletter'];
                    $myView->textmessage = $formData['textmessage'];
                    $myView->volunteer = $formData['volunteer'];
					$myView->tag = $formData['tag'];

                    $myView->addScriptPath(APPLICATION_PATH . '/views/scripts/membership');
                    $html_body = $myView->render('membership.email.phtml');

                    $mail->setType(Zend_Mime::MULTIPART_RELATED);
                    $mail->setBodyHtml($html_body);
                    $mail->send($transport);
                }
                	
                    // add dev mode to print the email page when email is not available.
                    $this->view->runner = $formData['id'];
                    $this->view->firstname = $formData['firstname'];
                    $this->view->surname = stripslashes($formData['surname']);
                    $this->view->gender = $formData['gender'];
                    $this->view->dateofbirth = $date->toString("y-M-d");
                    $this->view->address1 = $formData['address1'];
                    $this->view->address2 = $formData['address2'];
                    $this->view->address3 = $formData['address3'];
                    $this->view->email = $formData['email'];
                    $this->view->mobile = $formData['mobile'];
                    $this->view->sectorname = $formData['sectorname'];
                    $this->view->companyname = $formData['companyname'];
                    $this->view->newsletter = $formData['newsletter'];
                    $this->view->textmessage = $formData['textmessage'];
                    $this->view->volunteer = $formData['volunteer'];
                    $this->view->tag = $formData['tag'];
                    
					$runirelandUrl = "http://www.runireland.com/forms/bhaa-dublin-membership-2012";
                	if($formData['tag']!="bhaa2012")
                	{
                		$eventTable = new Model_DbTable_Event();
            			$e = $eventTable->getEventByTag($formData['tag']);
                		$runirelandUrl = $e->runireland;
                	}
                	$this->view->$runirelandurl = $runirelandurl;
                	
		            $runireland = sprintf($runirelandUrl.'?'.
		                    'id=%d&'.'firstname=%s&'.'surname=%s&'.
		                    'gender=%s&'.'dateofbirth=%s&'.
		                    'email=%s&'.'newsletter=%s&'.
		                    'mobilephone=%s&'.'textmessage=%s&'.
		                    'address1=%s&'.'address2=%s&'.'address3=%s&'.
		                    'companyname=%s&'.'volunteer=%s' ,
		                $formData['id'],
		                utf8_encode($formData['firstname']),
		                utf8_encode($formData['surname']),
		                $formData['gender'],
		                $date->toString("y-M-d"),
		                $formData['email'],
		                $formData['newsletter'],
		                $formData['mobile'],
		                $formData['textmessage'],
		                $formData['address1'],
		                $formData['address2'],
		                $formData['address3'],
		                $formData['companyname'],
		                $formData['volunteer']                
		                );
		            $this->view->runireland = $runireland;
                    return $this->_forward('confirmmembership');
	    	} 
		    else 
		    {
				$this->view->tag = $tag;
				$model->getForm()->getElement('tag')->setValue($tag);
		    	$model->getForm()->populate($model->getForm()->getValues());
		        $this->view->errors = $model->getForm()->getMessages();
		    }
		}
		// ensure the get parameters are set into the form
		$model->getForm()->setDefault("tag",$tag);

		$event;
    	if($tag!="bhaa2012")
        {
        	$eventTable = new Model_DbTable_Event();
            $event = $eventTable->getEventByTag($tag);
            $this->view->event = $event;
        }  
        
		$this->view->tag = $tag;
		$this->view->model = $model;        
    }

    public function noemailAction()
    {}

    public function editAction()
    {
        $logger = Zend_Registry::get('logger');

        $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }

        $form = new Form_MembershipForm();
        if ($this->_request->isPost()) {

            $formData = $this->_request->getPost();
            if($form->isValid($formData))
            {
                $table = new Model_DbTable_Membership();
                $mappeddata = array(
                        'firstname' => stripslashes($formData['firstname']),
                        'surname' => stripslashes($formData['surname']),
                        'address1' => $formData['address1'],
                        'address2' => $formData['address2'],
                        'address3' => $formData['address3'],
                        'standard' => $formData['standard'],
                        'gender' => $formData['gender'],
                        'company' => $formData['company'],
                        'dateofbirth' => $formData['dateofbirth'],
                        'email' => $formData['email'],
                        'newsletter' => $formData['newsletter'],
                        'telephone' => $formData['telephone'],
                        'mobilephone' => $formData['mobilephone'],
                        'textmessage' => $formData['textmessage'],
                        'volunteer' => $formData['volunteer'],
                        'insertdate' => $formData['insertdate'],
                        'dateofrenewal' => $formData['dateofrenewal'],
                        'type' => $formData['type']);
                $table->update($mappeddata,"id = ".$this->_request->getParam('id'));
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
            $memberTable = new Model_DbTable_Membership();
            $runner = $memberTable->getMember($this->_request->getParam('id'));

            $mappeddata = array(
                'id' => $runner->id,
                'firstname' => stripslashes($runner->firstname),
                'surname' => stripslashes($runner->surname),
                'gender' => $runner->gender,
                'dateofbirth' => $runner->dateofbirth,
                'company' => $runner->company,
                'companyname' => $runner->companyname,
                'address1' => $runner->address1,
                'address2' => $runner->address2,
                'address3' => $runner->address3,
                'email' => $runner->email,
                'newsletter' => $runner->newsletter,
                'mobile' => $runner->mobile,
                'textmessage' => $runner->textmessage,
                'volunteer' => $runner->volunteer,
                'insertdate' => $runner->insertdate,
                //'status' => $runner->status
            );
            $form->populate($mappeddata);
        }
        $this->view->form = $form;
    }
    
    public function confirmmembershipAction()
    {}
        
	public function renewAction()
    {
    	$code = $this->_request->getParam('code');
        $logger = Zend_Registry::get('logger');
         
        $renewalTable = new Model_DbTable_Renewal();
        $renewal = $renewalTable->getRenewal($code);
        $logger->info(sprintf("%s",$renewal->runner));
         
        if($renewal!=null)
        {
            $runnerTable = new Model_DbTable_Runner();
	        $runner = $runnerTable->getRunner($renewal->runner);
	        
	        $companyTable = new Model_DbTable_Company();
	        $company = $companyTable->getCompany($runner->company);
	    	
	        $sectorTable = new Model_DbTable_Sector();
	        $sector = $sectorTable->getSector($company->sector);
	        
	        $date = new Zend_Date($runner->dateofbirth);
	        
	    	$form = new Form_MembershipForm();
	    	$mappeddata = array(
		        'membershipnumber' => $runner->id,
	            'firstname' => $runner->firstname,
	            'surname' => stripslashes($runner->surname),
	        	'gender' => $runner->gender,
	            'sectorid' => $sector->id,
		        'sectorname' => $sector->name,
		        'sectorother' => "",
	            'company' => $company->id,
	            'companyname' => $company->name,
	            'companyother' =>"",
	            'dateofbirth' => $date->toString("dd/MM/YYYY"),
	        	'address1' => "",
	            'address2' => "",
	            'address3' => "",
	            'email' => $runner->email,
		        'newsletter' => "",
	            'mobile' => $runner->telephone,
		        'textmessage' => ""
			 );
			 $form->populate($mappeddata);
             $this->view->form = $form;
             //return $this->_forward('form');
        }
        else
        {
        	return $this->_forward('form');
        }
    }
    
    public function renewalsAction()
    {
	    $auth = Zend_Auth::getInstance();
        if (!$auth->hasIdentity()) {
            $this->_redirect('auth/login');
        }
        
    	$renewalTable = new Model_DbTable_Renewal();
        $renewals = $renewalTable->fetchAll();
    	$this->view->renewals = $renewals;
    }
    
    public function sendrenewalAction()
    {
    	$inviteid = $this->_request->getParam('runner');

    	$runnerTable = new Model_DbTable_Runner();
    	$runner = $runnerTable->getRunner($inviteid);
    	
    	$code = $this->str_makerand(128,128,true,false,true);
    	
    	$renewaldata = array(
    		'code'=>$code,
    		'runner'=>$runner->id,
    		'email'=>$runner->email,
    		'status'=>"I");
    	 
    	$renewalTable = new Model_DbTable_Renewal();
    	$renewalTable->insert($renewaldata);
    	
        $config = array('auth' => 'login',
            'username' => 'registrar@bhaa.ie',
            'password' => 'Passw0rd10',
            'ssl' => 'tls',
            'port' => 587);
        $transport = new Zend_Mail_Transport_Smtp('smtp.gmail.com', $config);
		Zend_Mail::setDefaultTransport($transport);
		$mail = new Zend_Mail();
	
		$mail->addTo($runner->email);		
		//$mail->setFrom('registration@bhaa.ie', 'BHAA Registrar');
		
		$mail->setFrom('registrar@bhaa.ie', 'BHAA Registrar');
		$mail->addBcc('registrar@bhaa.ie','BHAA Registrar BCC');
		$mail->setSubject(sprintf('%s %s : BHAA Membership 2010 Renewal Application Form',
			$runner->firstname,stripslashes($runner->surname)));

		$myView = new Zend_View();
		$myView->runner =$runner->id;
		$myView->firstname = $runner->firstname;
		$myView->surname = $runner->surname;
		$myView->code = $code;
		$myView->addScriptPath(APPLICATION_PATH . '/views/scripts/membership');
		$html_body = $myView->render('renewal.email.phtml');

		$mail->setType(Zend_Mime::MULTIPART_RELATED);
		$mail->setBodyHtml($html_body);
        $mail->send($transport);
    	
    	$this->_helper->redirector('renewals','membership');
    }
    
	function str_makerand ($minlength, $maxlength, $useupper, $usespecial, $usenumbers)
	{
		/*
		Author: Peter Mugane Kionga-Kamau
		http://www.pmkmedia.com
		
		Description: string str_makerand(int $minlength, int $maxlength, bool $useupper, bool $usespecial, bool $usenumbers)
		returns a randomly generated string of length between $minlength and $maxlength inclusively.
		
		Notes:
		- If $useupper is true uppercase characters will be used; if false they will be excluded.
		- If $usespecial is true special characters will be used; if false they will be excluded.
		- If $usenumbers is true numerical characters will be used; if false they will be excluded.
		- If $minlength is equal to $maxlength a string of length $maxlength will be returned.
		- Not all special characters are included since they could cause parse errors with queries.
		
		Modify at will.
		*/
		$charset = "abcdefghijklmnopqrstuvwxyz";
		if ($useupper) $charset .= "ABCDEFGHIJKLMNOPQRSTUVWXYZ";
		if ($usenumbers) $charset .= "0123456789";
		if ($usespecial) $charset .= "~@#$%^*()_+-={}|]["; // Note: using all special characters this reads: "~!@#$%^&*()_+`-={}|\\]?[\":;'><,./";
		if ($minlength > $maxlength) $length = mt_rand ($maxlength, $minlength);
		else $length = mt_rand ($minlength, $maxlength);
		for ($i=0; $i<$length; $i++) $key .= $charset[(mt_rand(0,(strlen($charset)-1)))];
		return $key;
	}
}
?>