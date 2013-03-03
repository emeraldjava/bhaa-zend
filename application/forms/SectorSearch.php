<?php
class Form_SectorSearch extends Zend_Form
{
    public function __construct($options = null) 
    { 
        parent::__construct($options);
        $this->setName('sector_search');
          
		// Create and configure username element:
    	$this->addElement('text', 'search');
    	$this->addElement('submit', 'login', array('label' => 'Search'));
    	
    	$this->setMethod('post');
        //$this->setAction('public/sector/search');
    }
}
?>