<?php
/**
 * http://havl.net/devnotes/2010/10/zendframework-model-orm/
 * http://codeutopia.net/blog/2009/02/28/creating-a-simple-abstract-model-to-reduce-boilerplate-code/
 * http://stackoverflow.com/questions/603935/zend-framework-using-models-and-views-best-practices
 * 
 * @author assure
 * 
 * @property int $id
 * @property string $firstname
 * @property string $surname
 * @property string $gender
 * @property date $dateofbirth
 * @property int $standard
 * @property string $status
 * @property string $address1
 * @property string $address2
 * @property string $address3
 * @property int $company
 * @property string $companyname
 * @property int $team
 * @property string $email
 * @property string $newsletter
 * @property string $mobilephone
 * @property string $textmessage
 * @property string $telephone
 * @property string $volunteer
 * @property string $extra
 * @property date $insertdate
 * @property date $dateofrenewal
 */
class Model_Runner extends Model_AbstractModel
{
	protected $dbTable = null;
		
	public function __construct()
	{
		parent::__construct();
		$this->_properties = array(
			'id' => null,
			'firstname' => null,
			'surname' => null,
			'status' => null,
			'extra'=> null,
			'gender' => null,
			'dateofbirth' => null,
			'standard' => null,
			'status' => null,
			'address1' => null,
			'address2' => null,
			'address3' => null,
			'company' => null,
			'companyname' => null,
			'team' => null,
			'email' => null,
			'newsletter' => null,
			'mobilephone' => null,
			'textmessage' => null, 
			'telephone' => null,
			'volunteer' => null,
			'extra' => null,
			'insertdate' => null,
			'dateofrenewal' => null
		);
	}
		
	/**
	 * Link the DB Table
	 * http://www.dragonbe.com/2010/01/zend-framework-data-models.html
	 */
	public function getDbTable()
	{
		if (null === $dbTable) {
			$dbTable = new Model_DbTable_Runners();
		}
		return $dbTable;
	}
	
	public function save()
	{
		$this->id = $this->getDbTable()->insert($this->toArray());
	}
}
?>