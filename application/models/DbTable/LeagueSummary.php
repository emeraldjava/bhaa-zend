<?php
/* 
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */

/**
 * Description of LeagueSummary
 *
 * @author assure
 */
// http://files.zend.com/help/Zend-Framework/zend.db.table.relationships.html
// http://naneau.nl/2007/04/21/a-zend-framework-tutorial-part-one/
class Model_DbTable_LeagueSummary extends Zend_Db_Table_Abstract {

    protected $_name = "leaguesummary";
    protected $_primary = array('leagueid', 'leaguetype','leagueparticipantid','leaguedivision');

//    protected $_referenceMap = array(
//        'Summary' => array(
//            'columns'           => array('leagueid'),
//            'refTableClass'     => 'Model_DbTable_League',
//            'refColumns'        => array('id')
//            )
        ////,
//        'MenA' =>array(
//            'columns'           => array('leagueid','leaguetype','leaguedivision'),
//            'refTableClass'     => 'Model_DbTable_League',
//            'refColumns'        => array("id","I","A")
//            )
      //  );

//    select ls.leagueposition,t.name, ls.leaguestandard, ls.leaguepoints
//    from leaguesummary ls
//    join team t on ls.leagueparticipantid=t.id
//    where leaguedivision <> 'w'
//    order by leagueposition asc
//    limit 10

    public function getSummary($id)
    {
        $sql = $this->select()
            ->from(array('leaguesummary'=>'leaguesummary'))
            ->where("leagueparticipantid = ?",$id);
        return $this->fetchAll($sql)->current();
    }

    /**
     * select leagueparticipantid,leaguedivision, leaguepoints from leaguesummary where leagueid=6
     * and leagueposition <=10 and leaguetype='I' order by leaguedivision,leagueposition;
     */
    public function getIndividualLeagueSummary($year,$leagueposition=10)
    {
        $sql = $this->select()
            ->from(array('leaguesummary'=>'leaguesummary'),
                array('leagueid','leagueparticipantid','leaguedivision','leaguepoints','leaguescorecount'))
            ->setIntegrityCheck(false)
            ->join(array('runner'=>'runner'),'leaguesummary.leagueparticipantid=runner.id',
                array('name'=>new Zend_Db_Expr('CONCAT(LEFT(firstname,1)," ",surname)')))
            ->join(array('division'=>'division'),'leaguesummary.leaguedivision=division.code and leaguesummary.leaguetype=division.type',
                array('divisionname'=>'name','min','max','gender'))
            ->join(array('league'=>'league'),'league.id=leaguesummary.leagueid',array('leaguename'=>'name'))
            ->where('( (YEAR(league.startdate) = ?) or (YEAR(league.enddate) = ?) )',$year,$year)
            ->where('leaguesummary.leaguetype = ?','I')
            ->where('leaguesummary.leagueposition <= ?',$leagueposition)
            ->order('leagueid')->order('leaguedivision')->order('leagueposition');
        return $this->fetchAll($sql);
    }

    public function getTeamLeagueSummary($year,$leagueposition=10)
    {
        $sql = $this->select()
            ->from(array('leaguesummary'=>'leaguesummary'),
                array('leagueid','leagueparticipantid','leaguedivision'=>'division.gender','leaguepoints','leaguescorecount'))
            ->setIntegrityCheck(false)
            ->join(array('team'=>'team'),'leaguesummary.leagueparticipantid=team.id',array('name'))
            ->join(array('division'=>'division'),'leaguesummary.leaguedivision=division.code and leaguesummary.leaguetype=division.type',
                array('divisionname'=>'name','min','max','gender'))
            ->join(array('league'=>'league'),'league.id=leaguesummary.leagueid',array('leaguename'=>'name'))
            ->where('( (YEAR(league.startdate) = ?) or (YEAR(league.enddate) = ?) )',$year,$year)
            ->where('leaguesummary.leaguetype = ?','T')
            ->where('leaguesummary.leagueposition <= ?',$leagueposition)
            ->order('leaguedivision')->order('leagueposition');
        //echo $sql;
        return $this->fetchAll($sql);
    }

//    select ls.leagueposition,r.firstname,r.surname, ls.leaguestandard, ls.leaguepoints
//    from leaguesummary ls
//    join runner r on ls.leagueparticipantid=r.id
//    where leaguedivision ='A'
//    order by leagueposition asc
//    limit 10;
    public function getRunnersByDivisionSQL($league,$division,$limit=10)
    {
        $sql = $this->select()
            ->from(array('leaguesummary'=>'leaguesummary'))
            ->setIntegrityCheck(false)
            ->join(array('runner'=>'runner'),
                'leaguesummary.leagueparticipantid=runner.id',
                array('firstname','surname'))
            ->where("leaguesummary.leaguedivision = ?",$division->code)
            ->where("leaguesummary.leagueid = ?",$league->id)
            ->order("leaguesummary.leagueposition asc")
            ->limit($limit);
        //echo $sql;
        return $sql;
    }

//    SELECT `leaguesummary`.*, team.* FROM `leaguesummary`
//    INNER JOIN `team` ON leaguesummary.leagueparticipantid=team.id
//    WHERE leaguesummary.leaguetype = 'T' and leaguesummary.leaguedivision='W'
//    ORDER BY `leaguesummary`.`leagueposition` asc LIMIT 10
    public function getTeamSummaryByGender($gender="W",$limit=10)
    {
        $sql = $this->select()
            ->from(array('leaguesummary'=>'leaguesummary'))
            ->setIntegrityCheck(false)
            ->join(array('team'=>'team'),
                'leaguesummary.leagueparticipantid=team.id',
                array('name','type'))
            ->where('leaguesummary.leaguetype = ?',"T")
            ->order('leaguesummary.leagueposition asc')
            ->limit($limit);
        if($gender=="W")
            $sql->where('leaguesummary.leaguedivision = ?',"W");
        else
            $sql->where('leaguesummary.leaguedivision != ?',"W");
        //echo $sql;
        return $this->fetchAll($sql);
    }

//    select r.id, r.firstname, r.surname, ls.leaguestandard, ls.leaguescorecount,
//    ls.leaguedivision, ls.leagueposition, ls.leaguepoints
//    from runner r
//    join company c on r.company = c.id
//    left join leaguesummary ls on r.id = ls.leagueparticipantid and ls.leaguetype='I' and
//    ls.leagueid=6
//    where c.sector = 1 and r.status='m'
//    order by ls.leagueposition asc;
    public function getIndividualLeagueSummayBySector($sectorid,$limit=20)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('runner'=>'runner'),array('id','firstname','surname'))
            ->join(array('company'=>'company'),'runner.company=company.id',array('companyid'=>'id','companyname'=>'name'))
            ->joinLeft(array('leaguesummary'=>'leaguesummary'),'leaguesummary.leagueparticipantid=runner.id AND leaguesummary.leaguetype="I"')
            ->where("leaguesummary.leagueid = ?",7)
            ->where("runner.status = ?","M")
            ->where("company.sector=?",$sectorid)
            ->order("leaguesummary.leagueposition asc")
            ->limit($limit);
        //echo $sql;
        return $this->fetchAll($sql);
    }

    //select t.id, t.name, ls.leaguescorecount, ls.leagueposition, ls.leaguepoints
    //from team t
    //join company c on t.parent=c.id
    //left join leaguesummary ls on t.id = ls.leagueparticipantid and ls.leaguetype='T' and
    //ls.leagueid=5
    //where c.sector = 29 and t.type='C'
    //order by ls.leaguedivision asc,  ls.leagueposition asc;
    public function getCompanyTeamLeagueSummayBySector($sectorid,$limit=10)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('team'=>'team'),array('id','name'))
            ->join(array('company'=>'company'),'team.parent=company.id',array('companyid'=>'id','companyname'=>'name'))
            ->joinLeft(array('leaguesummary'=>'leaguesummary'),'leaguesummary.leagueparticipantid=team.id AND leaguesummary.leaguetype="T"')
            ->where("leaguesummary.leagueid = ?",7)
            ->where("team.type = ?","C")
            ->where("company.sector=?",$sectorid)
            ->order("leaguesummary.leaguedivision asc")
            ->order("leaguesummary.leagueposition asc")
            ->limit($limit);
        echo $sql;
        return $this->fetchAll($sql);
    }

//select t.type, t.id as tid, t.name as tname, c.id as cid, c.name as cname
//from team t
//left join company c on t.type='C' and t.parent=c.id  and c.sector=4 and t.status='ACTIVE'
//left join sector s on t.parent=s.id and t.type='S'and s.id=4 and t.status='ACTIVE'
//LEFT JOIN leaguesummary ls ON ls.leagueparticipantid=t.id AND ls.leaguetype='T'
//WHERE ls.leagueid = 5 and (c.id is not null and t.type='C') or (s.id is not null and t.type='S');
    public function getTeamLeagueSummaryBySector($sectorid,$limit=10)
    {
        $select = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('team'=>'team'),array('type','id','name'))
            ->joinLeft(array('company'=>'company'),
                sprintf('team.parent=company.id and company.sector=%d and team.status="ACTIVE"',$sectorid),
                array('comid'=>'id','compname'=>'name'))
            ->joinLeft(array('sector'=>'sector'),
                sprintf('team.parent=sector.id and sector.id=%d and team.status="ACTIVE"',$sectorid),
                array())
            ->joinLeft(array('leaguesummary'=>'leaguesummary'),
                "leaguesummary.leagueparticipantid=team.id and leaguesummary.leaguetype='T'")
            ->where('leaguesummary.leagueid = 5')
            ->where(sprintf("company.id IS NOT NULL and team.type='%s'","C"))
            ->orWhere(sprintf("sector.id IS NOT NULL and team.type='%s'","S"));
        //echo $select;
        return $this->fetchAll($select);

    }

    //-- individual league result by company
    //select r.id, r.firstname, r.surname, ls.leaguestandard, ls.leaguescorecount,
    //ls.leaguedivision, ls.leagueposition, ls.leaguepoints
    //from runner r
    //join company c on r.company = c.id
    //left join leaguesummary ls on r.id = ls.leagueparticipantid and ls.leaguetype='I' and ls.leagueid=6
    //where c.id = 110 and r.status='m'
    //order by ls.leaguedivision asc,  ls.leagueposition asc;
    public function getIndividualLeagueByCompany($company,$leagueid,$limit=20)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('runner'=>'runner'),array('id','firstname','surname'))
            ->join(array('company'=>'company'),'runner.company=company.id',array('companyid'=>'id','companyname'=>'name'))
            ->joinLeft(array('leaguesummary'=>'leaguesummary'),'leaguesummary.leagueparticipantid=runner.id AND leaguesummary.leaguetype="I"')
            ->where("leaguesummary.leagueid = ?",$leagueid)
            ->where("runner.status = ?","M")
            ->where("company.id=?",$company)
            ->order("leaguesummary.leaguedivision asc")
            ->order("leaguesummary.leagueposition asc")
            ->limit($limit);
        return $this->fetchAll($sql);
    }

    public function getIndividualLeagueByTeam($team)
    {
        $sql = $this->select()
            ->setIntegrityCheck(false)
            ->from(array('runner'=>'runner'),array('id','firstname','surname'))
            ->join(array('teammember'=>'teammember'),'teammember.runner=runner.id',array())
            ->join(array('team'=>'team'),'team.id=teammember.team',array('companyid'=>'id','companyname'=>'name'))
            ->joinLeft(array('leaguesummary'=>'leaguesummary'),'leaguesummary.leagueparticipantid=runner.id AND leaguesummary.leaguetype="I"')
            ->where("leaguesummary.leagueid = ?",7)
            ->where("runner.status = ?","M")
            ->where("teammember.team = ?",$team)
            ->order("leaguesummary.leaguedivision asc")
            ->order("leaguesummary.leagueposition asc");
        //echo $sql;
        return $this->fetchAll($sql);
    }
}
?>