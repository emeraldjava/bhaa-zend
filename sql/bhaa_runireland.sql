DROP TABLE IF EXISTS `runireland`;
CREATE TABLE IF NOT EXISTS `runireland` (
  `sid` int(11),
  `date` date NOT NULL,
  `uid` varchar(20),
  `username` varchar(20),
  `type` varchar(20),
  `sku` varchar(20) NOT NULL,
  `bhaatag` varchar(20),
  `runnerid` varchar(20),
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `dateofbirth` date NOT NULL,
  `gender` varchar(1) NOT NULL,
  `email` varchar(50) NOT NULL,
  `mobile` varchar(10),
  `address1` varchar(20),
  `address2` varchar(20),
  `address3` varchar(20),
  `country` varchar(20),
  `ptype` varchar(20),
  `company` varchar(20),
  `textalert` varchar(1),
  `newsletter` varchar(1),
  `volunteer` varchar(1),
  `hearabout` varchar(30),  
  `paid` varchar(20),
  `amount` varchar(20),
  `orderid` varchar(20),
  PRIMARY KEY  (`sid`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

select * from runireland;
delete from runireland;
select * from runner where extra="rte2012";
delete from runner where extra="rte2012";
