<?php
/**
 * http://www.youtube.com/watch?v=n31mQGZxtbE
 * @author assure
 *
 */
class Racetec_Acl extends Zend_Acl 
{
  public function __construct() {
	// ROLES
  	$this->addRole(new Zend_Acl_Role('guest'));
    $this->addRole(new Zend_Acl_Role('info'), 'guest');
    $this->addRole(new Zend_Acl_Role('admin'), 'info');
    
    //Add a resource called page
    $this->add(new Zend_Acl_Resource('auth'));
    $this->add(new Zend_Acl_Resource('login'),'auth');
    $this->add(new Zend_Acl_Resource('logout'),'auth');
    $this->add(new Zend_Acl_Resource('error'));
    
    $this->add(new Zend_Acl_Resource('racetec'));
    $this->add(new Zend_Acl_Resource('member'),'racetec');
    $this->add(new Zend_Acl_Resource('day'),'racetec');
    $this->add(new Zend_Acl_Resource('latest'),'racetec');
    $this->add(new Zend_Acl_Resource('list'),'racetec');
    $this->add(new Zend_Acl_Resource('export'),'racetec');
    $this->add(new Zend_Acl_Resource('admin'),'racetec');
    $this->add(new Zend_Acl_Resource('summary'),'racetec');
    //$this->add(new Zend_Acl_Resource('idfilter'),'racetec');
    $this->add(new Zend_Acl_Resource('daymemberfilter'),'racetec');
    $this->add(new Zend_Acl_Resource('memberfilter'),'racetec');
    
    //Finally, we want to allow guests to view pages
    $this->allow(null, 'login');
    $this->allow(null, 'error');
    $this->allow(null, 'daymemberfilter');
    $this->allow(null, 'memberfilter');
    
    $this->allow('guest', 'racetec', array('index','latest','memberfilter','daymemberfilter','idfilter'));
    $this->allow('guest', 'auth', array('login','logout'));
    $this->deny('guest', 'login');

    // https://gist.github.com/258911
    $this->allow('info','racetec',array('index','latest','list','member'));
    $this->allow('admin','racetec',array('index','latest','list','member','day','admin','export','summary'));
  }
}
?>