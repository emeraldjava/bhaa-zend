<?php
class Form_MembershipForm extends Zend_Form
{
    public function init()
    {
        $this->setMethod('post');
        $this->setName('membershipform');
        
        $uppercaseValidator = new Zend_Filter_UpperCaseFirstLetter();

        $decors = array(
            array(array('Elem' => 'ViewHelper'), array('separator' => '')), // i reset the separators to get rid
            array('Description', array('tag'=>'span','class'=>'description','placement'=>'APPEND')),
            array('Label', array('separator' => '')),                       // those unpredictable newlines
            array('ErrorClass'),
            array('Errors', array('separator' => '')),                      // in the render output
        );
        
        $firstname = new Zend_Form_Element_Text('firstname');
        $firstname->setRequired(true);
    	$firstname->setDecorators($decors);
    	$firstname->setLabel('Firstname');
    	$firstname->size = 30;
    	
    	$firstname->addFilter($uppercaseValidator);
    	$this->addElement($firstname);
    	
    	$surname = new Zend_Form_Element_Text('surname');
        $surname->setFilters(array('StripSlashes'));
    	$surname->setRequired(true);
    	$surname->setDecorators($decors);
    	$surname->setLabel('Surname');
    	$surname->size = 30;
    	$surname->addFilter($uppercaseValidator);
    	$this->addElement($surname);

    	$gender = new Zend_Form_Element_Radio('gender');
    	$gender->setRequired(true);
    	$gender->setLabel('Gender');
    	$gender->addMultiOptions(array('M'=>'Male','W'=>'Female'));
    	$gender->setSeparator('');
    	$gender->setDecorators($decors);
    	$this->addElement($gender);
    	
    	$company = new Zend_Form_Element_Hidden('company');
        $company->setDecorators($decors);
    	$this->addElement($company);

        $companyname = new Zend_Form_Element_Text('companyname');
		$companyname->setRequired(true);
    	$companyname->setLabel('Company Name');
		$companyname->setDecorators($decors);
		$companyname->setAttrib('placeholder','Enter the first three letters of the company');
    	$this->addElement($companyname);
    	
    	$sectorid = new Zend_Form_Element_Hidden('sectorid');
    	$sectorid->setDecorators($decors);
    	$this->addElement($sectorid);
    	
    	$sectorname = new Zend_Form_Element_Radio('sectorname');
    	$sectorname->setRequired(false);
		$sectorname->setLabel('Sector');
		$sectorname->setSeparator(' ');
		$sectorTable = new Model_DbTable_Sector();
        $sectors = $sectorTable->listSectors();
        foreach($sectors as $sector)	
        {
            if($sector->id !=  48)
            	$sectorname->addMultiOption($sector->id,$sector->name);
        }
        $sectorname->setDecorators($decors);
        $this->addElement($sectorname);
    	
    	$dateofbirth = new Zend_Form_Element_Text('dateofbirth');
    	$dateofbirth->setRequired(true);
    	$dateofbirth->setLabel('DateOfBirth');
    	$dateofbirth->setDescription('DD/MM/YYYY');
    	$dateValidator = new Zend_Validate_Date('DD/MM/YYYY');
    	$dateValidator->setMessage('Date should be in format DD/MM/YYYY');
    	$dateofbirth->addValidator($dateValidator);
    	$dateofbirth->setDecorators($decors);
    	$this->addElement($dateofbirth);
    	
    	$address1 = new Zend_Form_Element_Text('address1');
    	$address1->setLabel('Address 1');
    	$address1->setDecorators($decors);
    	$this->addElement($address1);

    	$address2 = new Zend_Form_Element_Text('address2');
    	$address2->setLabel('Address 2');
    	$address2->setDecorators($decors);
    	$this->addElement($address2);
    	
    	$address3 = new Zend_Form_Element_Text('address3');
    	$address3->setLabel('Address 3');
    	$address3->setDecorators($decors);
    	$this->addElement($address3);
    	
    	$email = new Zend_Form_Element_Text('email');
    	$email->setLabel('Email');
    	$email->size = 40;
    	$emailvalidator = new Zend_Validate_EmailAddress();
    	$email->addValidator($emailvalidator);
    	$email->setRequired(true);
    	$email->setDecorators($decors);
    	$this->addElement($email);
    	
    	$newsletter = new Zend_Form_Element_Radio('newsletter'); 
    	$newsletter->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$newsletter->setLabel('Newsletter');
    	$newsletter->setDecorators($decors);
    	$newsletter->setRequired(true);
    	$this->addElement($newsletter);
    	
    	$mobile = new Zend_Form_Element_Text('mobile');
    	$mobile->setRequired(true);
    	$mobilelenghtValidator = new Zend_Validate_StringLength(10);
    	$mobilelenghtValidator->setMessage('Mobile should ten digits, e.g:0879876543.');
    	$mobile->addValidator($mobilelenghtValidator);
    	$mobilevalidator = new Zend_Validate_Digits();
    	$mobilevalidator->setMessage('Mobile should only have numbers.');
    	$mobile->addValidator($mobilevalidator);
    	$mobile->setLabel('Mobile');
		$mobile->setDecorators($decors);
    	$this->addElement($mobile);
    	
    	$textmessage = new Zend_Form_Element_Radio('textmessage'); 
    	$textmessage->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$textmessage->setLabel('TextAlert');
    	$textmessage->setRequired(true);
    	$textmessage->setDecorators($decors);
    	$this->addElement($textmessage);
    	    	
    	$id = new Zend_Form_Element_Hidden('id');
    	$id->setDecorators($decors);
    	$this->addElement($id);
    	
//    	$type = new Zend_Form_Element_Hidden('type');// array('disableLoadDefaultDecorators' => true)
//    	$type->setDecorators($decors);
//    	$this->addElement($type);
    	
    	$tag = new Zend_Form_Element_Hidden('tag');
    	$tag->setDecorators($decors);
    	$this->addElement($tag);
    	
    	$hearabout = new Zend_Form_Element_Text('hearabout');
    	$hearabout->setRequired(false);
    	$hearabout->size = 90;
    	$hearabout->setLabel('Hear');
		$hearabout->setDecorators($decors);
		$hearabout->setAttrib('placeholder','Where did you hear about the BHAA?');
    	$this->addElement($hearabout);
    	    	
    	$volunteer = new Zend_Form_Element_Radio('volunteer');
    	$volunteer->setRequired(true);
    	$volunteer->setLabel('volunteer');
    	$volunteer->setDescription("Are you going to volunteer you fucker!");
    	$volunteer->addMultiOptions(array('Y'=>'I will be available to volunteer ','N'=>'I will not be available to volunteer'));
    	$volunteer->setSeparator('');
    	$volunteer->setDecorators($decors);
    	$this->addElement($volunteer);
    }
    
    public function loadDefaultDecorators() 
    {
    	$this->setDecorators(
        	array(
        		array('ViewScript',array('viewScript' => 'membership/membership.layout.phtml'))
        	)
		);        
	}
}
?>