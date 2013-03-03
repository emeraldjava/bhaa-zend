<?php
class Form_RunirelandForm extends Zend_Form
{
    public function __construct($options = null) 
    {
    	parent::__construct($options);
        $this->setMethod('post');
		$this->setAttrib('enctype', 'multipart/form-data');
		
        $decors = array(
            array('ViewHelper'),
            array('HtmlTag'),//array('tag'=>'table')),
            array('Label', array('separator' => ' ')),                       // those unpredictable newlines
            array('Errors', array('separator' => ' ')),                      // in the render output
        );
 
        $file = new Zend_Form_Element_File('file');
        $file->setDestination('/home/assure/bhaa/zend/trunk/public/upload');
		$file->setLabel('Document File Path')
			  ->setRequired(true)
	          ->addValidator('NotEmpty');
	     $this->addElement($file);
		
    	$submit = new Zend_Form_Element_Submit('submit');
        $submit->setLabel('Upload File');
        $this->addElement($submit);
    }
}
?>