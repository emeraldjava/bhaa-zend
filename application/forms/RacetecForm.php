<?php
class Form_RacetecForm extends Zend_Form
{
	public function __construct($options = null)
	{
		parent::__construct($options);
	    // http://domeq.net/development/zend-form-styled.html
        $this->setAttrib('class','twoColumns inlineLabels');
    }
	
    public function init()
    {
        $this->setMethod('post');
        
        $uppercaseFilter = new Filter_UpperCaseFirstLetter();

        $commaRegexFilter = new Zend_Filter_PregReplace();
        $commaRegexFilter->setMatchPattern(array("#,#"))->setReplacement(array(""));
        
        $regexValidator = new Zend_Validate_Regex(array('pattern'=>"#[0-9A-Za-z\s&']#"));
        $regexValidator->setMessage("Only letters, numbers, ', & and spaces are allowed.");
        
        $racenumber = new Zend_Form_Element_Text('racenumber');
        $racenumber->setRequired(true);
        $racenumber->setLabel('Racenumber');
        $racenumber->setAttrib('autocomplete','off');
        $racenumber->size = 30;
        $racenumbervalidator = new Zend_Validate_Db_NoRecordExists('racetec','racenumber');
        $racenumbervalidator->setMessage('Race number %value% is already assigned.',Zend_Validate_Db_Abstract::ERROR_RECORD_FOUND);
        $racenumber->addValidator($racenumbervalidator);
        $digitValidator = new Zend_Validate_Digits();
        $digitValidator->setMessage('Race number cannot contain letters.');
        $racenumber->addValidator($digitValidator);
        
        $eventTable = new Model_DbTable_Event();
        $eventDB = $eventTable->getNextEvent();
         
        $raceTable = new Model_DbTable_Race();
        $races = $raceTable->getEventRaces($eventDB->id);
         
        $event = new Zend_Form_Element_Select('event');
        $event->setRequired(true);
        $event->setLabel('Race');
        $event->setSeparator(' ');
        foreach($races as $race)
        {
        	$event->addMultiOption(
        		$race->distance.'_'.$race->unit,
        		$race->category.' '.$race->distance.' '.$race->unit);
        }
        $event->setValue($races[0]->distance.'_'.$races[0]->unit);
            	
    	$firstname = new Zend_Form_Element_Text('firstname');
    	$firstname->setRequired(true);
    	$firstname->setLabel('Firstname');
    	$firstname->size = 30;
    	$firstname->addFilters(array('StripTags','StringTrim','HtmlEntities',$commaRegexFilter));//$uppercaseFilter
    	$firstname->addValidators(array($regexValidator));
    	
    	$surname = new Zend_Form_Element_Text('surname');
    	$surname->setRequired(true);
    	$surname->setLabel('Surname');
    	$surname->size = 30;
    	$surname->addFilters(array('StripTags','StringTrim','HtmlEntities',$commaRegexFilter));//$uppercaseFilter
    	$surname->addValidators(array($regexValidator));
    	
    	$runner = new Zend_Form_Element_Text('runner');
    	$runner->setLabel('ID');
    	$runner->setAttrib('readonly','true');
    	$runner->setRequired(true);
    	$runner->size = 30;
    	$runnervalidator = new Zend_Validate_Db_NoRecordExists(
    		array('table'=>'racetec',
    	    	'field'=>'runner',
    	    	'exclude' => array ('field' => 'runner', 'value' => 'DAY'))
    		);
    	$runnervalidator->setMessage('BHAA Runner with ID %value% is already assigned.',Zend_Validate_Db_Abstract::ERROR_RECORD_FOUND);
    	$runner->addValidator($runnervalidator);
    	 
    	$gender = new Zend_Form_Element_Select('gender');
    	$gender->setRequired(true);
    	$gender->setLabel('Gender');
    	$gender->addMultiOptions(array(
	    	   'M' => 'Male',
	    	   'F' => 'Female'
	    	));
    	$gender->setSeparator('');
    	    	 
    	$dateofbirth = new Zend_Form_Element_Text('dateofbirth');
    	$dateofbirth->setRequired(true);
    	$dateofbirth->setAttrib('placeholder','19YY-MM-DD');
    	$dateofbirth->setAttrib('autocomplete','off');
    	$regexDateValidator = new Zend_Validate_Regex(
    			array('pattern' => '/^[1]{1}[9]{1}[0-9]{2}-[0|1]{1}[0-9]{1}-[0|1|2|3]{1}[0-9]{1}$/')
    	);
    	$regexDateValidator->setMessage(
    			"Date does not match the format '19YY-MM-DD'",
    			Zend_Validate_Regex::NOT_MATCH
    	);
    	$dateofbirth->addValidator($regexDateValidator);
		//$dateofbirth->addValidator(new Zend_Validate_Date('YYYY-MM-DD'));
    	$dateofbirth->setLabel('Date of Birth');
    	$dateofbirth->size = 30;
    	
    	$agecat = new Zend_Form_Element_Hidden('agecat');
    	
    	$companyname = new Zend_Form_Element_Text('companyname');
    	$companyname->setLabel('Company');
    	$companyname->size = 30;
    	$companyname->addFilters(array('StripTags','StringTrim','HtmlEntities',$commaRegexFilter));
    	$companyname->addValidators(array($regexValidator));
    	
    	$companyid = new Zend_Form_Element_Hidden('companyid');

    	/*- OPTIONAL FIELDS BELOW -*/
    	$standard = new Zend_Form_Element_Text('standard');
    	$standard->setLabel('Standard');
    	$standard->size = 2;

    	$teamname = new Zend_Form_Element_Text('teamname');
    	$teamname->setLabel('Team');
    	$teamname->size = 30;
    	$teamname->addFilters(array('StripTags','StringTrim','HtmlEntities',$commaRegexFilter));
    	$teamname->addValidators(array($regexValidator));
    	 
    	$teamid = new Zend_Form_Element_Hidden('teamid');
    	$dateofrenewal = new Zend_Form_Element_Hidden('dateofrenewal');
    	    	
    	$email = new Zend_Form_Element_Text('email');
    	$email->setLabel('Email');
    	$email->size = 40;
    	$emailvalidator = new Zend_Validate_EmailAddress();
    	$email->addValidator($emailvalidator);
    	 
    	$newsletter = new Zend_Form_Element_Radio('newsletter');
    	$newsletter->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$newsletter->setLabel('Newsletter');
    	 
    	$mobile = new Zend_Form_Element_Text('mobile');
    	$mobilelenghtValidator = new Zend_Validate_StringLength(10);
    	$mobilelenghtValidator->setMessage('Mobile should ten digits, e.g:0879876543.');
    	$mobile->addValidator($mobilelenghtValidator);
    	$mobilevalidator = new Zend_Validate_Digits();
    	$mobilevalidator->setMessage('Mobile should only have numbers.');
    	$mobile->addValidator($mobilevalidator);
    	$mobile->setLabel('Mobile');
    	 
    	$textmessage = new Zend_Form_Element_Radio('textmessage');
    	$textmessage->addMultiOptions(array('Y'=>'Yes','N'=>'No'));
    	$textmessage->setLabel('TextAlert');
    	
    	//$type = new Zend_Form_Element_Hidden('type');
    	$type = new Zend_Form_Element_Hidden('type');
    	//$type->setLabel("Type");
    	$type->setAttrib('readonly','true');
    	
    	//$status = new Zend_Form_Element_Hidden('type');
    	$status = new Zend_Form_Element_Hidden('status');
    	//$status->setLabel("Status");
    	$status->setAttrib('readonly','true');

    	//http://domeq.net/development/zend-form-styled.html
    	$submit = new Zend_Form_Element_Submit('submit');
    	$submit->setLabel('Register');//->setAttrib('class','btn-submit');
    	
    	$subform = new Zend_Form_SubForm();
    	$subform->setName('raceSubForm');
    	$subform->setIsArray(false);
    	$subform->setLegend('Race '.$eventDB->tag.' Details');
    	 
    	$subform2 = new Zend_Form_SubForm();
    	$subform2->setName('runnerSubForm');
    	$subform2->setIsArray(false);
    	$subform2->setLegend('Runner Details');
    	 
    	$subform->addElements(array($racenumber,$event,$type,$status));
    	$subform2->addElements(array($runner,$firstname,$surname,$gender,$dateofbirth,$companyname,
    			$standard,$teamname,$agecat,$teamid,$companyid,$dateofrenewal));//,$email,$mobile
    	 
    	$this->addSubForm($subform,$subform->getName(),-1);
    	$this->addSubForm($subform2,$subform2->getName(),0);
    	$this->addElement($submit);
    }
}
?>