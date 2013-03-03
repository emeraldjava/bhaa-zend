<?php
class BHAA_Acl extends Zend_Acl 
{
  public function __construct() {
    //Add a new role called "default"
    $this->addRole(new Zend_Acl_Role('default'));
 
    //Add a role called admin, which inherits from default
    $this->addRole(new Zend_Acl_Role('admin'), 'default');
 
    //Add a resource called page
    $this->add(new Zend_Acl_Resource('index'));
 
    //Add a resource called news, which inherits page
    $this->add(new Zend_Acl_Resource('admin'), 'index');
 
    //Finally, we want to allow guests to view pages
    $this->allow('default','index','view');
 
    //and users can comment news
    $this->allow('admin','admin','edit');
  }
}
?>