<?php
class Form_RunnerForm extends Zend_Form
{
    public function init()
    {
        $this->setMethod('post');

        $decors = array(
            array('ViewHelper'),
            array('HtmlTag'),//array('tag'=>'table')),
            array('Label', array('separator' => ' ')),                       // those unpredictable newlines
            array('Errors', array('separator' => ' ')),                      // in the render output
        );
        
    	$id = new Zend_Form_Element_Text('id');
    	$id->size = 4;
    	$id->setLabel('RunnerID');
        $id->setDecorators($decors);
    	$this->addElement($id);

       	$standard = new Zend_Form_Element_Text('standard');
    	$standard->size = 4;
    	$standard->setLabel('Standard');
        $standard->setDecorators($decors);
    	$this->addElement($standard);

        $status = new Zend_Form_Element_Radio('status');
        $status->addMultiOptions(array('M'=>'Member','I'=>'Inactive','D'=>'Day'));
    	$status->setSeparator('');
    	$status->setDecorators($decors);
    	//$status->setAttrib('disabled', 'disabled');
    	$status->setLabel('Status');
    	$status->size = 1;
    	$this->addElement($status);

        $firstname = new Zend_Form_Element_Text('firstname');
    	$firstname->setDecorators($decors);
    	$firstname->setLabel('Firstname');
    	$firstname->size = 30;
    	$this->addElement($firstname);

    	$surname = new Zend_Form_Element_Text('surname');
        $surname->setFilters(array('StripSlashes'));
    	$surname->setDecorators($decors);
    	$surname->setLabel('Surname');
    	$surname->size = 30;
    	$this->addElement($surname);

    	$gender = new Zend_Form_Element_Radio('gender');
    	$gender->setLabel('Gender');
    	$gender->addMultiOptions(array('M'=>'Male','W'=>'Female'));
    	$gender->setSeparator('');
    	$gender->setDecorators($decors);
    	$this->addElement($gender);

    	$company = new Zend_Form_Element_Text('company');
        $company->setLabel('Company');
    	$company->setDecorators($decors);
    	$this->addElement($company);

    	$dateofbirth = new Zend_Form_Element_Text('dateofbirth');
    	$dateofbirth->setLabel('Date Of Birth');
    	$dateofbirth->setDescription('DD/MM/YYYY');
    	$dateofbirth->setDecorators($decors);
    	$this->addElement($dateofbirth);

        $address1 = new Zend_Form_Element_Text('address1');
    	$address1->setLabel('Address1');
    	$address1->setDecorators($decors);
    	$this->addElement($address1);

    	$address2 = new Zend_Form_Element_Text('address2');
    	$address2->setLabel('Address2');
    	$address2->setDecorators($decors);
    	$this->addElement($address2);

    	$address3 = new Zend_Form_Element_Text('address3');
    	$address3->setLabel('Address3');
    	$address3->setDecorators($decors);
    	$this->addElement($address3);

    	$email = new Zend_Form_Element_Text('email');
    	$email->setLabel('Email');
    	$email->size = 40;
    	$email->setDecorators($decors);
    	$this->addElement($email);

    	$newsletter = new Zend_Form_Element_Radio('newsletter');
    	$newsletter->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$newsletter->setLabel('NewsLetter');
    	$newsletter->setDecorators($decors);
    	$this->addElement($newsletter);

       	$telephone = new Zend_Form_Element_Text('telephone');
    	$telephone->setLabel('Telephone');
        $telephone->setDecorators($decors);
    	$this->addElement($telephone);

    	$mobile = new Zend_Form_Element_Text('mobilephone');
    	$mobile->setLabel('Mobile');
        $mobile->setDecorators($decors);
    	$this->addElement($mobile);

    	$textmessage = new Zend_Form_Element_Radio('textmessage');
    	$textmessage->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$textmessage->setLabel('TextMessage');
    	$textmessage->setDecorators($decors);
    	$this->addElement($textmessage);

       	$textmessage = new Zend_Form_Element_Radio('volunteer');
    	$textmessage->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$textmessage->setLabel('Volunteer');
    	$textmessage->setDecorators($decors);
    	$this->addElement($textmessage);

       	$insertdate = new Zend_Form_Element_Text('insertdate');
        $insertdate->setLabel('InsertDate');
    	$insertdate->setDecorators($decors);
    	$this->addElement($insertdate);

       	$dateofrenewal = new Zend_Form_Element_Text('dateofrenewal');
        $dateofrenewal->setLabel('DateofRenewal');
    	$dateofrenewal->setDecorators($decors);
    	$this->addElement($dateofrenewal);

    	$submit = new Zend_Form_Element_Submit('submit');
        $submit->setLabel('Save Runner');
        $this->addElement($submit);
    }
}
?>