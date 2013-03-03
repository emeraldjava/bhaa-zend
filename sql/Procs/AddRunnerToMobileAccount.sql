DELIMITER $$

DROP PROCEDURE IF EXISTS `bhaa1_members`.`AddRunnerToMobileAccount` $$
CREATE PROCEDURE `bhaa1_members`.`AddRunnerToMobileAccount` (_runner int)
BEGIN

DECLARE _account INT;

SET _account =
  (
  select account
  from textalert
  group by account
  having count(runner) <125
  limit 1
  );

if (_account is not null) then

  if not exists (select runner from textalert where runner =_runner) then
    insert into textalert(runner, account,startdate)
    values(_runner, _account, curdate());
  end if;

end if;

END $$

DELIMITER ;