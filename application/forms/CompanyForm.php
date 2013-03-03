<?php
class Form_CompanyForm extends Zend_Form
{
    public function init()
    {
        $this->setMethod('post');
        
        $decors = array(
            //array(array('Elem' => 'ViewHelper'), array('separator' => '</br>')), // i reset the separators to get rid
            array('ViewHelper'),
            array('HtmlTag'),
        	array('Description', array('tag'=>'span','class'=>'description','placement'=>'APPEND')),
            array('Label', array('separator' => ' ')),                       // those unpredictable newlines
            array('Errors', array('separator' => ' ')),                      // in the render output
        );
        
	   	$id = new Zend_Form_Element_Hidden('id');
    	$this->addElement($id);
    	
    	$name = new Zend_Form_Element_Text('name');
        $name->setRequired(true);
    	$name->setDecorators($decors);
    	$name->setLabel('name');
    	$name->size = 50;
    	$this->addElement($name);
    	
       	$sector = new Zend_Form_Element_Radio('sector');
		$sector->setLabel('sector');
		$sector->setSeparator(' ');
		$sectorTable = new Model_DbTable_Sector();
        $sectors = $sectorTable->listSectors();
        foreach($sectors as $sectorx)
        {
            if($sectorx->id !=  48)
            	$sector->addMultiOption($sectorx->id,$sectorx->name);
        }
        $sector->setDecorators($decors);
        $this->addElement($sector);

    	
    	$website = new Zend_Form_Element_Text('website');
        $website->setRequired(false);
    	$website->setDecorators($decors);
    	$website->setLabel('website');
    	$website->size = 100;
    	$this->addElement($website);
    	
    	$image = new Zend_Form_Element_Text('image');
        $image->setRequired(false);
    	$image->setDecorators($decors);
    	$image->setLabel('image');
    	$image->size = 100;
    	$this->addElement($image);
    	
    	$submit = new Zend_Form_Element_Submit('submit');
        $submit->setLabel('Save Company');
        $this->addElement($submit);
    }
}
?>