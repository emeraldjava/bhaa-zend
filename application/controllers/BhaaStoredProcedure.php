<?php
/**
 * Description of StoredProcedure
 * @author assure
 */
class BhaaStoredProcedure 
{
    public function processTeams($leagueid,$raceid,$gender)
    {
    	$this->action(sprintf("CALL addScoringTeams(%d,%d,'%s')",$leagueid,$raceid,$gender));
    	$this->action(sprintf("CALL updateScoringTeamTotals(%d)",$raceid));
    	$this->action(sprintf("CALL updateScoringTeamClasses(%d,'%s')",$raceid,$gender));
    }

    /**
     * CALL updateScoringTeamPointsByGender('W'); #5.
     */
    public function finaliseTeams($gender)
    {
    	$this->action(sprintf("CALL updateScoringTeamPointsByGender('%s')",$gender));
    }

    public function updateResultsByEventId($eventid)
    {
    	$this->action(sprintf("CALL updateResultsByEventId(%d)",$eventid));
    }

    public function clearEventResultsData($eventid)
    {
    	$this->action(sprintf("CALL clearEventResultsData(%d)",$eventid));
    }

    public function updateraceresultSPS($raceid)
    {
    	$this->action(sprintf('CALL updatePaceByRaceId(%d)',$raceid));
    	$this->action(sprintf('CALL updatePositionInAgeCategoryByRaceId(%d)',$raceid));
    	$this->action(sprintf('CALL updatePositionInStandardByRaceId(%d)',$raceid));
    	$this->action(sprintf('CALL updatePostRaceStandard(%d)',$raceid));
    }

    public function updateIndividualLeagueSummary($id)
    {
    	$this->action(sprintf("CALL updateIndividualLeagueSummary(%d)",$id));
    }

    public function updateTeamLeagueSummary($id)
    {
    	$this->action(sprintf("CALL updateTeamLeagueSummary(%d)",$id));
    }

    public function addRaceOrganiser($league,$race,$runner)
    {
    	$this->action(sprintf("CALL AddRaceOrganiser(%d,%d,%d)",$league,$race,$runner));
    }

    public function addRaceVolunteer($league,$race,$runner)
    {
    	$this->action(sprintf("CALL AddRaceVolunteer(%d,%d,%d)",$league,$race,$runner));
    }
    
    public function updateRaceTimeByHandicap($event)
    {
    	$this->action(sprintf("CALL updateRaceTimeByHandicap(%d)",$event));
    }
    
    public function action($command)
    {
    	$start = microtime(true);
    	$db = Zend_Db_Table::getDefaultAdapter();
    	$sql = $db->prepare($command);
    	$sql->execute();
    	$sql->closeCursor();
    	// http://www.lornajane.net/posts/2011/dealing-with-mysql-gone-away-in-zend-framework
    	//$db->closeConnection();
    	$stop = microtime(true);
    	$logger = Zend_Registry::get('logger');
    	$time = ($stop-$start);
    	$logger->info(sprintf('action: %s => %f ms',$command,$time));
    	return $time;
    }
    
    public function updateRacePositions($race)
    {
    	$start = microtime(true);
    	$insert = sprintf("insert into tmp_raceresult ".
	    	" select race, runner, @row:=@row+1 ".
	    	" from raceresult, (SELECT @row:=0) r ".
	    	" where race=%d order by racetime ",$race);
    	 
    	$index = "alter table tmp_raceresult add index (race,runner)";
    	 
    	$update = "update raceresult, tmp_raceresult
	    	set raceresult.position=tmp_raceresult.position
	    	where raceresult.runner=tmp_raceresult.runner and raceresult.race=tmp_raceresult.race";
    	 
		$delete = "delete from tmp_raceresult";
    	
    	$db = Zend_Db_Table::getDefaultAdapter();
    	
    	$sql = $db->prepare($insert);
    	$sql->execute();
    	$sql->closeCursor();
    	
    	$sql = $db->prepare($index);
    	$sql->execute();
    	$sql->closeCursor();
    	
    	$sql = $db->prepare($update);
    	$sql->execute();
    	$sql->closeCursor();
    	
    	$sql = $db->prepare($delete);
    	$sql->execute();
    	$sql->closeCursor();
    	
    	$stop = microtime(true);
    	$logger = Zend_Registry::get('logger');
    	$time = ($stop-$start);
    	$logger->info(sprintf('action: %s => %f ms',$command,$time));
    	return $time;
    }
}
?>