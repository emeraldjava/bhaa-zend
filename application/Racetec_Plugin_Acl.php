<?php
class Racetec_Plugin_Acl extends Zend_Controller_Plugin_Abstract {
 	
// 	private $_acl = null;
//     private $_auth = null;

//     public function __construct(Zend_Acl $acl, Zend_Auth $auth)
//     {
//         $this->_acl = $acl;
//         $this->_auth = $auth;
//     }
    
    /**
     * http://stackoverflow.com/questions/545702/help-with-zend-acl
     * @param Zend_Controller_Request_Abstract $request
     */
    public function preDispatch(Zend_Controller_Request_Abstract $request)
    {
    	$loginController = 'auth';
    	$loginAction     = 'login';
    
    	$auth = Zend_Auth::getInstance();
    
    	// If user is not logged in and is not requesting login page
    	// - redirect to login page.
    	if (!$auth->hasIdentity()
    	&& $request->getControllerName() != $loginController
    	&& $request->getActionName()     != $loginAction) {
    
    		$redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('Redirector');
    		$redirector->gotoSimpleAndExit($loginAction, $loginController);
    	}
    
    	// User is logged in or on login page.
    
    	if ($auth->hasIdentity()) {
    		// Is logged in
    		// Let's check the credential
    		$registry = Zend_Registry::getInstance();
    		$acl = $registry->get('acl');
                $identity = $auth->getIdentity();
    		// role is a column in the user table (database)
    		$isAllowed = $acl->isAllowed($identity->role,
    		$request->getControllerName(),
    		$request->getActionName());
    		if (!$isAllowed) {
	    		$redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('Redirector');
	    		$redirector->gotoUrlAndExit('auth/login');
    		}
    	}
    }

	public function xpreDispatch(Zend_Controller_Request_Abstract $request) {
		//As in the earlier example, authed users will have the role user
// 		$role = (Zend_Auth::getInstance()->hasIdentity())
// 		? 'guest'
// 		: 'guest';

// 		//For this example, we will use the controller as the resource:
// 		$resource = $request->getControllerName();

// 		if(!$this->_acl->isAllowed($role, $resource, 'index')) {
// 			//If the user has no access we send him elsewhere by changing the request
// 			$request->setControllerName('auth')
// 			->setActionName('login');
// 		}
		
		// https://gist.github.com/258911
		$resource = $request->getControllerName();
		$action = $request->getActionName();
		
		$role .= $this->_auth->getStorage()->read()->role;
		
		$logger = Zend_Registry::get('logger');
		$logger->info($action.' '.$resource.' '.$role);
		
		if(!$this->_acl->isAllowed($role, $resource, $action)) {
			$request->setControllerName('auth')->setActionName('login');
		}
	}
}
?>