DROP TABLE IF EXISTS `membership`;
CREATE TABLE IF NOT EXISTS `membership` (
  `id` int(11) NOT NULL auto_increment,
  `runner` int(4),
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `gender` enum('M','W') NOT NULL,
  `dateofbirth` date NOT NULL,
  `address1` varchar(50),
  `address2` varchar(50),
  `address3` varchar(50),
  `email` varchar(50) NOT NULL,
  `newsletter` enum('Y','N') default 'Y',
  `mobile` varchar(10),
  `textmessage` enum('Y','N') default 'Y',
  `companyid` int(4),
  `companyname` varchar(50),
  `companyother` varchar(50),
  `sectorid` int(4),
  `sectorname` varchar(50),
  `sectorother` varchar(50),
  `volunteer` enum('Y','N'),
  `insertdate` date NOT NULL,
  `status` enum('PENDING','NEW','RENEWAL') DEFAULT 'PENDING',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

ALTER TABLE `membership` ADD COLUMN `volunteer` enum('Y','N') AFTER `sectorother`;
ALTER TABLE `membership` ADD COLUMN `insertdate` DATE AFTER `volunteer`;
ALTER TABLE `membership` ADD COLUMN `status` enum('PENDING','NEW','RENEWAL') DEFAULT 'PENDING' AFTER `insertdate`;

ALTER TABLE `membership` ADD COLUMN `type` VARCHAR(20) 'NONE' AFTER `volunteer`;
ALTER TABLE `membership` ADD COLUMN `payment` enum('ONLINE','CASH','NONE') DEFAULT 'NONE' AFTER `volunteer`;
ALTER TABLE `membership` ADD COLUMN `hearabout` VARCHAR(100) AFTER `status`;

select count(id) from membership;

-- select matching
select membership.id,membership.runner,membership.surname,
runner.id,runner.surname,runner.dateofrenewal,runner.status from membership
join runner on membership.email=runner.email and membership.dateofbirth=runner.dateOfBirth
where membership.runner is null;

-- update member runner id
update membership
join runner on membership.email=runner.email and membership.dateofbirth=runner.dateOfBirth
set membership.runner=runner.id
where membership.runner is null;

select membership.id,membership.runner,membership.surname from membership
where membership.runner is null;


-- clear reg email
select id,runner,firstname,surname,email from membership where email="registrar@bhaa.ie";
update membership set email=NULL where email="registrar@bhaa.ie";

select id,firstname,surname,email from runner where email="registrar@bhaa.ie";
update runner set email=NULL where email="registrar@bhaa.ie";

--
select runner from membership
join runner on runner.id=membership.runner
where runner.dateofrenewal is NULL;

-- new members with no company
select runner.id,runner.firstname,runner.surname,runner.company,membership.companyid,membership.companyname from runner
join membership on membership.runner=runner.id
where runner.company=0
and runner.id>6000 and runner.id<7000 order by id desc;

select runner.id,runner.firstname,runner.surname,runner.company,runner.standard,membership.companyid,membership.companyname,membership.companyother from runner
left join membership on membership.runner=runner.id
where runner.company=0
and runner.id>6000 and runner.id<7000 order by id desc;

