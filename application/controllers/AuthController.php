<?php
class AuthController extends Zend_Controller_Action 
{
    function init()
    {
        $this->initView();
        $this->view->baseUrl = $this->_request->getBaseUrl();
    }
        
    function indexAction()
    {
        $this->_redirect('/');
    }
    
    function loginAction()
    {
        $this->view->message = '';
        if (strtolower($_SERVER['REQUEST_METHOD']) == 'post') {
            // collect the data from the user
            Zend_Loader::loadClass('Zend_Filter_StripTags');
            $filter = new Zend_Filter_StripTags();
            $username = $filter->filter($this->_request->getPost('username'));
            $password = $filter->filter($this->_request->getPost('password'));

            if (empty($username)) {
                $this->view->message = 'Please provide a username.';
            } else {
                // setup Zend_Auth adapter for a database table
                $dbAdapter = Zend_Db_Table::getDefaultAdapter();
        		
                //Zend_Loader::loadClass('Zend_Auth_Adapter_DbTable');
                //$dbAdapter = Zend_Registry::get('dbAdapter');
                $authAdapter = new Zend_Auth_Adapter_DbTable($dbAdapter);
                $authAdapter->setTableName('login');
                $authAdapter->setIdentityColumn('email');
                $authAdapter->setCredentialColumn('password');
                
                // Set the input credential values to authenticate against
                $authAdapter->setIdentity($username);
                $authAdapter->setCredential($password);
                
                // do the authentication 
                $auth = Zend_Auth::getInstance();
                $result = $auth->authenticate($authAdapter);
                if ($result->isValid()) {
                    // success : store database row to auth's storage system
                    // (not the password though!)
                    $data = $authAdapter->getResultRowObject(null, 'password');
                    $auth->getStorage()->write($data);
                    $logger = Zend_Registry::get('logger');
			        $logger->info('login '.$result->getIdentity());
                    $this->_helper->authRedirector();
                } else {
                    // failure: clear database row from session
                    $this->view->message = 'Login failed.';
                }
            }
        }
        $this->view->title = "Log in";
        $this->render();   
    }
    
    function logoutAction()
    {
    	$logger = Zend_Registry::get('logger');
        $logger->info('logout '.$this->user->name);
        Zend_Auth::getInstance()->clearIdentity();
        $this->_redirect('/');
    }
}
?>