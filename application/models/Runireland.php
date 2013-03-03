<?php
/**
 * http://havl.net/devnotes/2010/10/zendframework-model-orm/
 * http://codeutopia.net/blog/2009/02/28/creating-a-simple-abstract-model-to-reduce-boilerplate-code/
 * http://stackoverflow.com/questions/603935/zend-framework-using-models-and-views-best-practices
 * 
 * @author assure
 * 
 * @property int $sid
 * @property date $date
 * @property string $uid
 * @property string $username
 * @property string $type
 * @property string $sku
 * @property string $bhaatag
 * @property string $runnerid
 * @property string $firstname
 * @property string $surname
 * @property date $dateofbirth
 * @property string $gender
 * @property string $email
 * @property string $mobile
 * @property string $address1
 * @property string $address2
 * @property string $address3
 * @property string $country
 * @property string $ptype
 * @property string $company
 * @property string $textalert
 * @property string $newsletter
 * @property string $volunteer
 * @property string $hearabout
 * @property string $paid
 * @property string $amount
 * @property string $orderid
 *
 */
class Model_Runireland extends Model_AbstractModel
{
	protected $dbTable = null;
		
	public function __construct()
	{
		parent::__construct();
		$this->_properties = array(
    		'sid' => null,
    		'date' => null,
    		'uid' => null,
    		'username' => null,
    		'type' => null,
    		'sku' => null,
    		'bhaatag' => null,
    		'runnerid' => null,
    		'firstname' => null,
    		'surname' => null,
    		'dateofbirth' => null,
    		'gender' => null,
    		'email' => null,
    		'mobile' => null,
    		'address1' => null,
    		'address2' => null,
    		'address3' => null,
    		'country' => null,
    		'ptype' => null,
    		'company' => null,
    		'textalert' => null,
    		'newsletter' => null,
    		'volunteer' => null,
    		'hearabout' => null,
    		'paid' => null,
    		'amount' => null,
    		'orderid' => null);
	}
		
	/**
	 * Link the DB Table
	 * http://www.dragonbe.com/2010/01/zend-framework-data-models.html
	 */
	public function getDbTable()
	{
		if (null === $dbTable) {
			$dbTable = new Model_DbTable_Runireland();
		}
		return $dbTable;
	}
	
	public function save()
	{
		$this->sid = $this->getDbTable()->insert($this->toArray());
	}
	
	public function insertRunnerDetails($data)
	{
		$this->clear();
		
		$date = new Zend_Date($data[1],"dd/MM/YYYY");
		$dob = new Zend_Date($data[10],"dd/MM/YYYY");
		$this->sid = trim($data[0]);
		$this->date = $date->toString("YYYY-MM-dd");
		$this->uid= trim($data[2]);
		$this->username= trim($data[3]);
		$this->type= trim($data[4]);
		$this->sku= trim($data[5]);
		$this->bhaatag= trim($data[6]);
		$this->runnerid= trim($data[7]);
		$this->firstname= trim($data[8]);
		$this->surname= trim($data[9]);
		$this->dateofbirth= $dob->toString("YYYY-MM-dd");
		$this->gender= trim($data[11]);
		$this->email= trim($data[12]);
		$this->mobile= trim($data[13]);
		$this->address1= trim($data[14]);
		$this->address2= trim($data[15]);
		$this->address3= trim($data[16]);
		$this->country= trim($data[17]);
		$this->ptype= trim($data[18]);
		$this->company= trim($data[19]);
		$this->textalert= trim($data[20]);
		$this->newsletter= trim($data[21]);
		$this->volunteer= trim($data[22]);
		$this->hearabout= trim($data[23]);
		$this->paid= trim($data[24]);
		$this->amount= trim($data[25]);
		$this->orderid= trim($data[26]);
		
		$match= $this->getDbTable()->getRunner($data[0]);
		if(!$match)
		{
			$runnerModel = new Model_Runner();
			$runnerModel->firstname = $this->firstname;
			$runnerModel->surname = $this->surname;
			$runnerModel->gender = (($this->gender=="f")?"W":"M");
			$runnerModel->dateofbirth = $this->dateofbirth;
			
			$runnerModel->status = "D";
			$runnerModel->extra = strtolower($this->sku);

			$runnerModel->companyname = $this->company;
			$runnerModel->mobilephone = $this->mobile;
			$runnerModel->telephone = $this->sid;
			$runnerModel->email = $this->email;
			$runnerModel->textmessage = "N";
			$runnerModel->insertdate = Zend_Date::now()->toString("YYYY-MM-dd");
			
			$runnerModel->save();
			$this->logger->info(sprintf('runner %d %s %s',
					$runnerModel->id,$runnerModel->firstname,$runnerModel->surname));
	
			$this->runnerid = $runnerModel->id;
			$this->save();
			$this->logger->info(sprintf('insert runireland %d %d %s %s %s',$this->sid,$this->runnerid,$data[8],$data[9],$data[12]));
		}
		else
		{
			$this->logger->info(sprintf('exists %d %s %s %s',$data[0],$data[8],$data[9],$data[12]));
		}
	}
}
?>