<?php
class Model_DbTable_TeamRaceResult extends Zend_Db_Table_Abstract
{
	protected $_name = 'teamraceresult';
	protected $_primary = 'id';
	
	public function getTeamRaceResult($id)
    {
    	return $this->find($id)->current();
    }

	public function getMostRecentEventRaceDetails()
	{
        $sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('teamraceresult'=>'teamraceresult'))
    		->join(array('race'=>'race'),'race.id = teamraceresult.race')
    		->join(array('event'=>'event'),'race.event = event.id')
    		->where(sprintf('event.id = %d',$event));
        return $this->fetchAll($sql);

		$sql = $this->select()->from(array('event'=>'event'))
			->where("date < ?", new Zend_Db_Expr('now()'))
			->order("date desc")
			->limit(1);
		$rowset = $this->fetchAll($sql);
		return $rowset->current();
	}

    public function getTeamResultsForEvent($event)
    {
    	$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('teamraceresult'=>'teamraceresult'))
    		->join(array('race'=>'race'),'race.id = teamraceresult.race')
    		->join(array('event'=>'event'),'race.event = event.id')
    		->where(sprintf('event.id = %d',$event));
        return $this->fetchAll($sql);
    }

    public function getAllEventTeamResults($event)
	{
            $sql = $this->select()
                ->setIntegrityCheck(false)
                ->from(array('teamraceresult'=>'teamraceresult'),
                        array(
                            'id','team','standardtotal','positiontotal','class',
                            'runnerfirst',
                            '(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnerfirst) as r1sn',
                            'runnersecond',
                            '(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnersecond) as r2sn',
                            'runnerthird',
                            '(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnerthird) as r3sn')
                    )
                ->join(array('team'=>'team'),'team.id = teamraceresult.team',array('name'))
                ->join(array('race'=>'race'),'race.id = teamraceresult.race',array())
                ->where('race.event = ?',$event)
                ->where('teamraceresult.status="ACTIVE"')
                ->order(array('class asc','positiontotal asc','standardtotal asc'));
            $result = $this->fetchAll($sql);
        return $result;
	}

    public function getTeamDetailsSQL()
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('teamraceresult'=>'teamraceresult'),
                    array(
                        'id',
                        'team',
                        '(select name from team where team.id=team) as teamname',
                        'runnerfirst',
                        '(select CONCAT(firstname,\' \',surname) from runner where runner.id = runnerfirst) as r1sn',
                        'runnersecond',
                        '(select CONCAT(firstname,\' \',surname) from runner where runner.id = runnersecond) as r2sn',
                        'runnerthird',
                        '(select CONCAT(firstname,\' \',surname) from runner where runner.id = runnerthird) as r3sn',
                        'std'=>'standardtotal',
                        'pos'=>'positiontotal',
                        'class',
                        'leaguepoints',
                        'status')
                )
            ->where('status="PENDING"')
            ->order(array('class asc','standardtotal asc','positiontotal asc'));
        return $sql;
    }

	public function getTeamResults($race)
	{
		$sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('teamraceresult'=>'teamraceresult'),
    				array(
		    			'id','team','standardtotal','positiontotal','class',
		    			'runnerfirst',
		    			'(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnerfirst) as r1sn',
		    			'runnersecond',
		    			'(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnersecond) as r2sn',
		    			'runnerthird',
		    			'(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnerthird) as r3sn')
    			)
    		->join(array('team'=>'team'),'team.id = teamraceresult.team',array('name'))
    		->where('teamraceresult.race = ?',$race)
    		->order(array('class asc','positiontotal'));
    	return $this->fetchAll($sql);
	}

    /**
     * Create the team league query
     */
    public function getTeamLeague($races,$league,$gender)
	{

    //    SELECT t.id,t.name,trr.race,MAX(trr.leaguepoints) as points
    //    FROM teamraceresult trr
    //    JOIN team t on trr.team=t.id
    //    WHERE trr.league = 5 and trr.class!='W'
    //    GROUP BY t.id,t.name,trr.race
        $subquery = $this->select()->setIntegrityCheck(false)
            ->from(array('teamraceresult'=>'teamraceresult'),array('race','(select MAX(leaguepoints)) as points'))
            ->join(array('team'=>'team'),'teamraceresult.team=team.id',array('id','name','type'))
            ->where('teamraceresult.league=?',$league);
            if($gender=="W")
            {
                $subquery->where("teamraceresult.class='W'");
            }
            else
            {
                $subquery->where("teamraceresult.class!='W'");
            }
            $subquery->group('team.id')
            ->group('team.name')
            ->group('teamraceresult.race');

        //SELECT x.id,x.name,
        //SUM(CASE x.race WHEN 20102 THEN x.points ELSE NULL END) AS sdcc,
        //SUM(CASE x.race WHEN 20104 THEN x.points ELSE NULL END) AS eircom,
        //SUM(CASE x.race WHEN 20106 THEN x.points ELSE NULL END) AS ncf,
        //SUM(CASE x.race WHEN 20108 THEN x.points ELSE NULL END) AS airport,
        //SUM(CASE x.race WHEN 201010 THEN x.points ELSE NULL END) AS garda,
        //SUM(x.points) as total
        //FROM
        //(
        //   subquery
        //) x
        //GROUP BY x.id, x.name;
        $query = $this->select()->setIntegrityCheck(false)
          ->from(array('X' => new Zend_Db_Expr( '('.$subquery.')' ) ),array('id','name','type') );
          // for loop to list events.
            foreach($races as $taggedrace)
            {
                $query->columns(new Zend_Db_Expr(
                    sprintf("SUM(CASE X.race WHEN %d THEN X.points ELSE NULL END) as %s",
                        $taggedrace->raceid,$taggedrace->tag)));
            }
          $query->columns(new Zend_Db_Expr('(SUM(X.points)) as total'))
          ->group('X.id')
          ->group('X.name');

        //"SELECT A.id, A.name,
        //sdcc, eircom, ncf, airport, garda,
        //total - (SELECT COUNT(id) FROM teamraceresult WHERE team=A.Id AND class='O') as overall
        //FROM
        //(
        //    subquery
        //) A
        //ORDER by overall DESC;");
        $mainquery = $this->select()->setIntegrityCheck(false)
            ->from(array('A' => new Zend_Db_Expr( '('.$query.')' ) ),array('id','name','type') );
            // for loop to list events.
            foreach($races as $taggedrace)
            {
                $mainquery->columns( new Zend_Db_Expr($taggedrace->tag));
            }
            $mainquery->columns(
                new Zend_Db_Expr(sprintf(
                    'total - (select count(teamraceresult.id) from teamraceresult join race r on teamraceresult.race=r.id '.
                    'where (r.type="C" or r.type="%s") and team=A.id and class="O" and teamraceresult.league= %s) as overall',$gender,$league)))
                ->order('overall desc');
         return $this->fetchAll($mainquery);
	}

    /**
     *  select race,event.tag,
        runnerfirst,
        (select CONCAT(runner.firstname,' ',runner.surname) from runner where runner.id = runnerfirst) as r1sn,
        runnersecond,
        (select CONCAT(runner.firstname,' ',runner.surname) from runner where runner.id = runnersecond) as r2sn,
        runnerthird,
        (select CONCAT(runner.firstname,' ',runner.surname) from runner where runner.id = runnerthird) as r3sn,
        standardtotal,positiontotal,class,leaguepoints
        from teamraceresult
        join race on race.id=teamraceresult.race
        join event on event.id = race.event
        where team=49;
     */
    public function getResultsForTeam($team)
    {
        $sql = $this->select()
    		->setIntegrityCheck(false)
    		->from(array('teamraceresult'=>'teamraceresult'),
    				array(
		    			'team'=>'event.id',
    					'name'=>'event.tag',
		    			'runnerfirst',
		    			'(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnerfirst) as r1sn',
		    			'runnersecond',
		    			'(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnersecond) as r2sn',
		    			'runnerthird',
		    			'(select CONCAT(firstname,\' \',surname) from runner where runner.id = teamraceresult.runnerthird) as r3sn',
                        'standardtotal','positiontotal','class'))
    		->join(array('race'=>'race'),'race.id = teamraceresult.race',array())
       		->join(array('event'=>'event'),'event.id = race.event',array('tag'))
    		->where('teamraceresult.team = ?',$team)
    		->order('event.date desc')
    		->limit(10);
    	return $this->fetchAll($sql);
    }

    public function updateTeamResultsStatusForEvent()
    {
        $data = array("status" => "ACTIVE");
        return $this->update($data, 'status = "PENDING"');
    }
}
?>