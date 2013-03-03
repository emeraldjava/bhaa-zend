<?php
require_once 'BHAA_Acl.php';

class AuthPlugin extends Zend_Controller_Plugin_Abstract
{
	private $_acl = null;
 
  	public function __construct() {
    	$this->_acl = new BHAA_Acl();
  	}
//  	public function __construct(Zend_Acl $acl) {
//    	$this->_acl = $acl;
//  	}
  
    public function preDispatch(Zend_Controller_Request_Abstract $request)
    {
        $loginController = 'index';
        $loginAction     = 'index';

        $auth = Zend_Auth::getInstance();

        // If user is not logged in and is not requesting login page
        // - redirect to login page.
//        if (!$auth->hasIdentity()
//                && $request->getControllerName() != $loginController
//                && $request->getActionName()     != $loginAction) {
//
//            $redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('Redirector');
//            $redirector->gotoSimpleAndExit($loginAction, $loginController);
//        }

        // User is logged in or on login page.

        if ($auth->hasIdentity()) {
            // Is logged in
            // Let's check the credential
            //$registry = Zend_Registry::getInstance();
            //$acl = $registry->get('acl');
            $identity = $auth->getIdentity();
            // role is a column in the user table (database)
            $isAllowed = $acl->isAllowed($identity->role,
                                         $request->getControllerName(),
                                         $request->getActionName());
            echo sprintf("acl %s %s",$identity,$isAllowed);
            if (!$isAllowed) {
                //$redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('Redirector');
                //$redirector->gotoUrlAndExit('/');
                $this->_redirect('admin/index');
            }
            else
            {
            	$this->_redirect('event/index');
            }
        }
        else
        {
        	$request->setControllerName('index');
            $request->setActionName('index');
        	//$redirector = Zend_Controller_Action_HelperBroker::getStaticHelper('Redirector');
        	//$redirector->getActionController()->getFrontController()->re ('/');#
        	//Zend_Controller_Front::getInstance()->redirect('index');
        }
    }
}
?>