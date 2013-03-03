<?php
class Model_DbTable_Runner extends Zend_Db_Table_Abstract
{
	protected $_name = 'runner';
	protected $_primary = 'id';
	
	var $logger;
	
	public function init()
	{
		$this->logger = Zend_Registry::get('logger');
	}

	public function getRunner($runner)
	{
		return $this->find($runner)->current();
	}

	public function getRunnerDetails($runner)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('runner'=>'runner'))
			->columns(sprintf('(select getAgeCategory(dateofbirth,"%s",gender,0)) as agecategory',Zend_Date::now()->toString("YYYY-MM-dd")))
			->columns('(select count(raceresult.race) from raceresult where raceresult.runner = runner.id AND raceresult.class="RAN") as totalraces')
			->columns('(select SEC_TO_TIME( SUM( TIME_TO_SEC( raceresult.racetime ) ) ) from raceresult where raceresult.runner = runner.id) as totalracetime')
			->joinLeft(array('company'=>'company'),'company.id = runner.company',array('companyid'=>'id','companyname'=>'name'))
			->joinLeft(array('teammember'=>'teammember'),'teammember.runner = runner.id',array())
			->joinLeft(array('team'=>'team'),'team.id=teammember.team',array('teamid'=>'id','teamname'=>'name'))
			->joinLeft(array('textalert'=>'textalert'),'textalert.runner=runner.id',array('account'=>'account'))
			->joinLeft(array('mobileaccount'=>'mobileaccount'),'textalert.runner=runner.id AND mobileaccount.id=textalert.account',array('username'=>'username'))
			->joinLeft(array('leaguesummary'=>'leaguesummary'),'leaguesummary.leagueparticipantid=runner.id',
			array('leagueid','leaguetype','leagueparticipantid','leaguestandard','leaguedivision','leagueposition','previousleagueposition','leaguescorecount','leaguepoints'))
			->where(sprintf('runner.id = %d',$runner))
			->order('leagueid desc')
			->limit(1);
		return $this->fetchAll($sql)->current();
	}

	public function membershipDetails()
	{
		$sql = $this->select()
		->from(array('runner'=>'runner'),array(
                'count(id) as total',
                '(select count(id) from runner where status="M") as members',
                '(select count(id) from runner where YEAR(insertdate)=2012 and dateofrenewal>="2012-01-01") as newmembers',
                '(select count(id) from runner where YEAR(insertdate)!=2012 and dateofrenewal>="2012-01-01") as renewedmembers',
                '(select count(id) from runner where dateofrenewal>="2011-10-01" and dateofrenewal<"2012-01-01") as octmembers',
                '(select count(id) from runner where status="I") as inactive',
                '(select count(id) from runner where status="D") as day',
                '(select NOW()) as date'
		));
		return $this->fetchRow($sql);
	}

	public function existingMember($firstname,$surname,$dateofbirth)
	{
		$sql = $this->select()
			->from(array('runner'=>'runner'),array('id'))
			->where('id<=10000')
			->where("LOWER(firstname) = LOWER(?)",$firstname)
			->where("LOWER(surname) = LOWER(?)",$surname)
			->where("dateofbirth = ?",$dateofbirth);
		return $this->fetchAll($sql)->current();
	}

	public function existingMember2($firstname,$surname,$dateofbirth)
	{
		$sql = $this->select()
		->from(array('runner'=>'runner'),array('id'))
		->where(sprintf("id<=10000 and UPPER(runner.firstname) = '%s' and UPPER(surname) = '%s' and dateOfBirth = '%s'",$firstname,$surname,$dateofbirth));
		$this->logger->info(sprintf('sql %s',$sql));
		return $this->fetchAll($sql)->current();
	}

	public function getRunnerRaceResults($id)
	{
		$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('runner'=>'runner'),array('runner'=>'runner.id','status'))
			->join(array('rr'=>'raceresult'),'rr.runner = runner.id',
			array('position','points','racetime','paceKM','standard','postRaceStandard','racenumber'))
			->join(array('race'=>'race'),'race.id = rr.race',array('distance','unit','race'=>'race.id'))
			->join(array('event'=>'event'),'event.id = race.event',array('id','name','tag','date','racepixs'))
			// INNER JOIN `racepointsdata`AS rpd ON rr.runner=rpd.runner  and rr.race=rpd.race
			->joinLeft(array('racepointsdata'=>'racepointsdata'),'racepointsdata.runner = runner.id and racepointsdata.race=race.id',array('positioninstandard','positioninagecategory','positioninscoringset'))
			->order('event.date asc')
			->where('rr.class in ("RAN","RAN_NO_SCORE")')
			->where('runner.id = ?',$id);
		//echo $sql;
		return $this->fetchAll($sql);
	}

	public function getRunnersByCompany($company)
	{
		$sql = $this->select()
		->setIntegrityCheck(false)
		->from(array('runner'=>'runner'),array('id',
                    'firstname',
                    'surname',
                    'gender',
                    'standard',
                    '(select count(race) from raceresult where raceresult.runner = runner.id and raceresult.race>2000) as races'))
		->where('runner.status="M"')
		->where("runner.company = ?",$company)
		->order('surname asc');
		return $this->fetchAll($sql);
	}

	public function exists($id)
	{
		$sql = $this->select()
		->from(array('runner'=>'runner'))
		->where('runner.id = ?',$id);
		return $this->fetchRow($sql);
	}

	public function lastID()
	{
		return $this->_db->lastInsertId();
	}

	public function searchActiveRunnersByName($runnername)
	{
		$sql = $this->select()
		->from(array('runner'=>'runner',array('id')))
		->where("status!='D'")
		->where("CONCAT(firstname,' ',surname) like ?",'%'.$runnername.'%')->limit(15);
		return $this->fetchAll($sql);
	}

	public function searchActiveRunnersByFullNameOrID($query)
	{
		//$this->logger->log($query,Zend_Log::DEBUG);
		if(preg_match('/[0-9]{4}/',$query))
		{
			$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('runner'=>'runner'),array('*','agecat'=>'(select getAgeCategory(runner.dateofbirth,curdate(),runner.gender,0)) as agecat'))
			->joinLeft(array('teammember'=>'teammember'),'teammember.runner = runner.id AND teammember.leavedate IS NULL',array())
			->joinLeft(array('company'=>'company'),'runner.company = company.id',array('companyname'=>'name','companyid'=>'id'))
			->joinLeft(array('team'=>'team'),'teammember.team = team.id AND team.status="ACTIVE"',array('teamname'=>'name','teamid'=>'id'))
			->where("runner.id = ?",$query);
			//$this->logger->log($sql,Zend_Log::DEBUG);
			return $this->fetchAll($sql);
		}
		else
		{
			$sql = $this->select()
			->setIntegrityCheck(false)
			->from(array('runner'=>'runner'),array('*','agecat'=>'(select getAgeCategory(runner.dateofbirth,curdate(),runner.gender,0)) as agecat'))
			->joinLeft(array('teammember'=>'teammember'),'teammember.runner = runner.id AND teammember.leavedate IS NULL',array())
			->joinLeft(array('company'=>'company'),'runner.company = company.id',array('companyname'=>'name','companyid'=>'id'))
			->joinLeft(array('team'=>'team'),'teammember.team = team.id AND team.status="ACTIVE"',array('teamname'=>'name','teamid'=>'id'))
			->where("runner.status!='D'")
			->where("CONCAT(firstname,' ',surname) like ?",'%'.$query.'%')
			->limit(15);
			//$this->logger->log($sql,Zend_Log::DEBUG);
			return $this->fetchAll($sql);
		}
	}
	
	public function registrationRunnerById($id)
	{
		$sql = $this->select()
		->setIntegrityCheck(false)
		->from(array('runner'=>'runner'),array('*','agecat'=>'(select getAgeCategory(runner.dateofbirth,curdate(),runner.gender,0)) as agecat'))
		->joinLeft(array('teammember'=>'teammember'),'teammember.runner = runner.id AND teammember.leavedate IS NULL',array())
		->joinLeft(array('company'=>'company'),'runner.company = company.id',array('companyname'=>'name','companyid'=>'id'))
		->joinLeft(array('team'=>'team'),'teammember.team = team.id AND team.status="ACTIVE"',array('teamname'=>'name','teamid'=>'id'))
		->where("runner.id = ?",$id);
		return $this->fetchAll($sql);
	}

	public function searchDayMembersByFullName($query)
	{
		if(preg_match('/[0-9]{5}/',$query))
		{
			$sql = $this->select()
				->setIntegrityCheck(false)
				->from(array('runner'=>'runner'))//,array('*','agecat'=>'(select getAgeCategory(runner.dateofbirth,curdate(),runner.gender,0)) as agecat'))
				->where("runner.id = ?",$query);
				//$this->logger->log($sql,Zend_Log::DEBUG);
			return $this->fetchAll($sql);
		}
		else
		{
			$sql = $this->select()
				->setIntegrityCheck(false)
				->from(array('runner'=>'runner'))//,array('*','agecat'=>'(select getAgeCategory(runner.dateofbirth,curdate(),runner.gender,0)) as agecat'))
				->where("status='D'")
				->where("CONCAT(firstname,' ',surname) like ?",'%'.$query.'%')
				->limit(10);
				//$this->logger->log($sql,Zend_Log::DEBUG);
			return $this->fetchAll($sql);
		}
	}

	public function searchAllRunnersByName($runnername)
	{
		$sql = $this->select()
		->from(array('runner'=>'runner'))//,array('id','surname','firstname','status'))
		->where("surname like ?",'%'.$runnername.'%');
		//$this->logger->log($sql,Zend_Log::DEBUG);
		return $this->fetchAll($sql);
	}

	public function exportRunnerData($eventdate,$letterStart,$letterEnd,$date,$status)
	{
		$sql = $this->select()
		->setIntegrityCheck(false)
		->from(array('runner'=>'runner'),
		array('id as membno','surname','firstname as name',
						'(CASE gender WHEN "M" THEN "M" ELSE "L" END) as gender',
						'standard as std',
						'date_format(dateofbirth,\'%d/%m/%Y\') as dateofbirth',
		sprintf('(select getAgeCategory(runner.dateofbirth,"%s",runner.gender,1)) as cat',$eventdate),
						'(select name from company where runner.company = company.id) as companyname'))
		->joinLeft(
		array('teammember'=>'teammember'),
	                    'teammember.runner = runner.id AND teammember.leavedate IS NULL',
		array('(select id from team where team.id=teammember.team and team.status="ACTIVE") as teamid'))
		->where('teammember.leavedate IS NULL')
		->where(sprintf("runner.status='%s'",$status))
		->where(sprintf("runner.dateofrenewal>='%s'",$date))
		->where(sprintf("LEFT(surname,1) regexp '[%s-%s]'",$letterStart,$letterEnd))
		->order(array('surname asc','firstname asc'));
		//$this->logger->log($sql,Zend_Log::DEBUG);
		return $this->fetchAll($sql);
	}
	
	public function exportRunirelandData($eventtag)
	{
		$sql = $this->select()
		->setIntegrityCheck(false)
		->from(array('runner'=>'runner'),
				array('id as membno','surname','firstname as name',
						'gender',
						'standard as std',
						'date_format(dateofbirth,\'%d/%m/%Y\') as dateofbirth',
						sprintf('(select getAgeCategory(runner.dateofbirth,"%s",runner.gender,1)) as cat',$eventdate),
						'companyname'))
		->where(sprintf("runner.extra='%s'",$eventtag))
		//->where(sprintf("runner.dateofrenewal>='%s'",$date))
		//->where(sprintf("LEFT(surname,1) regexp '[%s-%s]'",$letterStart,$letterEnd))
		->order(array('surname asc','firstname asc'));
		$this->logger->log($sql,Zend_Log::DEBUG);
		return $this->fetchAll($sql);
	}

	/**
	 * select id,firstname,surname,runner.email,
		(select count(race) from raceresult where raceresult.runner = runner.id and raceresult.race>2000) as races from runner
		where team=29 and status="M" order by races desc;
		*/
	public function getRunnersBySector($sector)
	{
		$sql = $this->select()
		->setIntegrityCheck(false)
		->from(array('runner'=>'runner'),array('id','firstname','surname','company','team',
                '(select count(race) from raceresult where raceresult.runner = runner.id and raceresult.race>2000) as races'))
		->joinleft('teammember','teammember.runner=runner.id',array('teammember.team'))
		->where("status='M'")
		->where(sprintf("runner.team= %d",$sector))
		->where('teammember.runner IS NULL')
		->order('races desc');
		return $this->fetchAll($sql);
	}

	public function getNextRunnerId()
	{
		//(select max(id+1) from runner where id>6000 and id<7000) as newid'
		$sql = $this->select()
		->from(array('runner'=>'runner'),
		array('(select max(id+1) from runner where id>=1500 and id<3638) as newid'));
		return $this->fetchRow($sql);
	}

	public function findMatchingRunners($firstname,$surname,$dateofbirth)
	{
		$sql = $this->select()->from(array('runner'=>'runner'),array('id','firstname','surname','status'));
		if($firstname!=""&&$firstname!=NULL)
		$sql->where(sprintf('firstname LIKE "%s"',$firstname));
		if($surname!=""&&$surname!=NULL)
		$sql->where(sprintf('surname LIKE "%s"',$surname));
		if($dateofbirth!=""&&$dateofbirth!=NULL)
		$sql->where(sprintf('dateofbirth LIKE "%s"',$dateofbirth));
		return $this->fetchAll($sql);
	}
}
?>