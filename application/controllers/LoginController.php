<?php
class LoginController extends Zend_Controller_Action
{
    public function getForm()
    {
        return new Bhaa_Form_Login(array(
            'action' => '/login/process',
            'method' => 'post',
        ));
    }
    
    public function indexAction()
    {
        $this->view->form = $this->getForm();
    }
    
	public function processAction()
    {
        $request = $this->getRequest();

        // Check if we have a POST request
        if (!$request->isPost()) {
            return $this->_helper->redirector('index');
        }

        // Get our form and validate it
        $form = $this->getForm();
        if (!$form->isValid($request->getPost())) {
            // Invalid entries
            $this->view->form = $form;
            return $this->render('index'); // re-render the login form
        }

        // Get our authentication adapter and check credentials
        //$adapter = $this->getAuthAdapter($form->getValues());
        //$auth    = Zend_Auth::getInstance();
        //$result  = $auth->authenticate($adapter);
        
        $result = $this->getAuthAdapter($form->getValues(),
        	$this->getRequest()->getPost('username'),
        	$this->getRequest()->getPost('password'));
//        if (!$result->isValid()) {
//            // Invalid credentials
//            $form->setDescription('Invalid credentials provided');
//            $this->view->form = $form;
//            return $this->render('index'); // re-render the login form
//        }
//        else
//        {
//	        // We're authenticated! Redirect to the home page
//    	    $this->_helper->redirector('index','index');        	
//        }
    }
    
	public function logoutAction()
    {
    	echo "logout";
        Zend_Auth::getInstance()->clearIdentity();
        $this->_helper->redirector('index'); // back to login page
//        $this->_helper->redirector->gotoRoute( 
//		    array( 
//		        'controller' => 'index', 
//		        'action' => 'index' 
//		    ));
    }

    public function getAuthAdapter(array $params, $username, $password)
    {
        // Leaving this to the developer...
        // Makes the assumption that the constructor takes an array of
        // parameters which it then uses as credentials to verify identity.
        // Our form, of course, will just pass the parameters 'username'
        // and 'password'.
        $dbAdapter = Zend_Db_Table::getDefaultAdapter();
        $authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);

        $authAdapter->setTableName('login')
                    ->setIdentityColumn('email')
                    ->setCredentialColumn('runner');
                    //->setCredentialTreatment('MD5(?)');

        // pass to the adapter the submitted username and password
        $authAdapter->setIdentity($username)
                    ->setCredential($password);
		
        $select = $authAdapter->getDbSelect();
		
        $auth = Zend_Auth::getInstance();
        $result = $auth->authenticate($authAdapter);
        if ($result->isValid()) {
                     // success : store database row to auth's storage system
                     // (not the password though!)
                     $data = $authAdapter->getResultRowObject(null);
                     $auth->getStorage()->write($data);
                     //$this->_redirect('/');
                     return $this->_helper->redirector('index','index');
                 } else {
                     // failure: clear database row from session
                     $this->view->message = 'Login failed.';
                     return $this->redirect('/');
                 }
        return $result;
    }
    
	public function preDispatch()
    {
        if (Zend_Auth::getInstance()->hasIdentity()) {
            // If the user is logged in, we don't want to show the login form;
            // however, the logout action should still be available
            if ('logout' != $this->getRequest()->getActionName()) {
                $this->_helper->redirector('index', 'index');
            }
        } else {
            // If they aren't, they can't logout, so that action should
            // redirect to the login form
            if ('logout' == $this->getRequest()->getActionName()) {
                $this->_helper->redirector('index');
            }
        }
    }
}
?>