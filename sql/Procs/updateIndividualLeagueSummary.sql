DROP PROCEDURE `updateIndividualLeagueSummary`//
CREATE DEFINER=`bhaa1`@`localhost` PROCEDURE `updateIndividualLeagueSummary`(_leagueid INT)
BEGIN
 DECLARE _nextDivision VARCHAR(2);
   DECLARE no_more_rows BOOLEAN;
   DECLARE loop_cntr INT DEFAULT 0;
   DECLARE num_rows INT DEFAULT 0;
   DECLARE _divisionCursor CURSOR FOR SELECT code FROM division WHERE type ='I';
   DECLARE CONTINUE HANDLER FOR NOT FOUND SET no_more_rows = TRUE;

DELETE FROM leaguesummary WHERE leagueType='I' and leagueId = _leagueId;
   OPEN _divisionCursor;
   SELECT FOUND_ROWS() into num_rows;

    the_loop: LOOP

    FETCH  _divisionCursor INTO   _nextDivision;

    IF no_more_rows THEN
        CLOSE _divisionCursor;
        LEAVE the_loop;
    END IF;

	INSERT INTO leaguesummary(
								leagueid,
								leaguetype,
								leagueparticipantid,
								leaguestandard,
								leaguedivision,
								leagueposition,

previousleagueposition,
								leaguescorecount,
								leaguepoints)

	SELECT

	t1.leagueid,
	t1.leaguetype,
	t1.leagueparticipantid,
	t1.leaguestandard,
	t1.leagueclass,
	@rownum:=@rownum+1 AS currentLeaguePosition,
	t1.previousleagueposition,
	t1.leaguescorecount,
	t1.leaguepoints

	FROM
	(
	SELECT
	lrd.league AS leagueid,
	'I' AS leaguetype,
	lrd.runner AS leagueparticipantid,
	lrd.standard AS leaguestandard,
	d.code AS leagueclass,
	null AS previousleagueposition,
	lrd.racesComplete AS leaguescorecount,
	lrd.pointsTotal AS leaguepoints
	FROM leaguerunnerdata lrd
  JOIN runner r ON lrd.runner = r.id
	JOIN division d ON (lrd.standard BETWEEN d.min AND d.max) AND d.type='I' and
d.gender= r.gender
	LEFT JOIN leaguesummary ls ON ls.leagueparticipantid = lrd.runner and
ls.leagueId =
	lrd.league
	WHERE lrd.league = _leagueid AND d.code=_nextDivision
	ORDER BY lrd.pointsTotal desc, lrd.racesComplete desc, lrd.standard desc
	) t1, (SELECT @rownum:=0) t2;

    SET loop_cntr = loop_cntr + 1;

  END LOOP the_loop;
END