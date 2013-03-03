<?php
// http://stackoverflow.com/questions/534870/zend-form-how-do-i-make-it-bend-to-my-will
class Form_DayMemberForm extends Zend_Form
{
    public function init()
    {
        $this->setMethod('post');

        $decors = array();
        $decors = array(
            array(array('Elem' => 'ViewHelper'), array('separator' => '')), // i reset the separators to get rid
            array('Description', array('tag'=>'span','class'=>'description','placem ent'=>'APPEND')),
            array('Label', array('separator' => '')),                       // those unpredictable newlines
            array('Errors', array('separator' => '')),                      // in the render output
        );

//        $decors = array(
//            'ViewHelper',
//            'Description',
//            'Errors',
//            array(array('data'=>'HtmlTag'), array('tag' => 'td')),
//            array('Label', array('tag' => 'td')),
//            array(array('row'=>'HtmlTag'),array('tag'=>'tr'))
//        );

        //$this->removeDecorator('HtmlTag') ->removeDecorator('DtDdWrapper') ->removeDecorator('Label') ->removeDecorator('Errors');

//        $this->setDecorators(array(
//               'FormElements',
//               array(array('data'=>'HtmlTag'),array('tag'=>'table')),
//               'Form'
//       ));

		$eventid = new Zend_Form_Element_Hidden("eventid");
		$eventid->setDecorators($decors);
		$this->addElement($eventid);

        $firstname = new Zend_Form_Element_Text('firstname');
        $firstname->setRequired(true);
    	$firstname->setDecorators($decors);
    	$firstname->setLabel('Firstname');
    	$firstname->size = 30;
    	$this->addElement($firstname);

    	$surname = new Zend_Form_Element_Text('surname');
    	$surname->setRequired(true);
    	$surname->setDecorators($decors);
    	$surname->setLabel('Surname');
    	$surname->size = 30;
    	$this->addElement($surname);

    	$gender = new Zend_Form_Element_Radio('gender');
    	$gender->setRequired(true);
    	$gender->setLabel('Gender');
    	$gender->addMultiOptions(array('M'=>'Male','F'=>'Female'));
    	$gender->setSeparator('');
    	$gender->setDecorators($decors);
    	$this->addElement($gender);

    	$company = new Zend_Form_Element_Hidden('company');
        $company->setDecorators($decors);
    	$this->addElement($company);

        $companyname = new Zend_Form_Element_Text('companyname');
		$companyname->setRequired(true);
    	$companyname->setLabel('Name');
		$companyname->setDecorators($decors);
        $companyname->size = 30;
    	$this->addElement($companyname);

        $sectorid = new Zend_Form_Element_Hidden('sectorid');
    	$sectorid->setDecorators($decors);
    	$this->addElement($sectorid);

    	$sectorname = new Zend_Form_Element_Radio('sectorname');
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
    	$dateofbirth->setLabel('Date Of Birth');
    	$dateofbirth->setDescription('DD/MM/YYYY');
    	$dateValidator =new Zend_Validate_Date('DD/MM/YYYY');
    	$dateValidator->setMessage('Date should be in format DD/MM/YYYY');
    	$dateofbirth->addValidator($dateValidator);
    	$dateofbirth->setDecorators($decors);
    	$this->addElement($dateofbirth);

    	$address1 = new Zend_Form_Element_Text('address1');
    	$address1->setLabel('Address 1');
    	$address1->setDecorators($decors);
        $address1->size = 30;
    	$this->addElement($address1);

    	$address2 = new Zend_Form_Element_Text('address2');
    	$address2->setLabel('Address 2');
    	$address2->setDecorators($decors);
        $address2->size = 30;
    	$this->addElement($address2);

    	$address3 = new Zend_Form_Element_Text('address3');
    	$address3->setLabel('Address 3');
    	$address3->setDecorators($decors);
        $address3->size = 30;
    	$this->addElement($address3);

    	$email = new Zend_Form_Element_Text('email');
    	$email->setLabel('Email');
    	$emailvalidator = new Zend_Validate_EmailAddress();
    	$email->addValidator($emailvalidator);
    	$email->setRequired(true);
    	$email->setDecorators($decors);
        $email->size = 30;
    	$this->addElement($email);

       	$newsletter = new Zend_Form_Element_Radio('newsletter');
    	$newsletter->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$newsletter->setLabel('Receive News Letter : ');
    	$newsletter->setDecorators($decors);
    	$this->addElement($newsletter);

    	$mobile = new Zend_Form_Element_Text('mobile');
    	//$mobile->setRequired(true);
    	$mobilelenghtValidator = new Zend_Validate_StringLength(10);
    	$mobilelenghtValidator->setMessage('Mobile should ten digits, e.g:0879876543.');
    	$mobile->addValidator($mobilelenghtValidator);
    	$mobilevalidator = new Zend_Validate_Digits();
    	$mobilevalidator->setMessage('Mobile should only have numbers.');
    	$mobile->addValidator($mobilevalidator);
    	$mobile->setLabel('Mobile');
        $mobile->size = 10;
		$mobile->setDecorators($decors);
    	$this->addElement($mobile);

       	$textmessage = new Zend_Form_Element_Radio('textmessage');
    	$textmessage->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$textmessage->setLabel('Receive Text Message : ');
    	$textmessage->setDecorators($decors);
    	$this->addElement($textmessage);

       	$submit = new Zend_Form_Element_Submit('submit');
        $submit->setDecorators($decors);
        $this->addElement($submit);
    }

    public function loadDefaultDecorators()
    {
    	$this->setDecorators(
        	array(
        		array('ViewScript',array('viewScript' => 'event/daymember.layout.phtml'))
        	)
		);
	}
}
?>