DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `id` int(11) NOT NULL auto_increment,
  `email` varchar(50) NOT NULL,
  `password` varchar(50) NOT NULL,
  `name` varchar(50) NOT NULL,
  `membernumber` int(11),
  `role` varchar(50) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB DEFAULT CHARSET=utf8;

insert into login VALUES(NULL,"guest","guest","guest",1,"guest");
insert into login VALUES(NULL,"info","info","info",1,"info");
insert into login VALUES(NULL,"admin","admin","admin",1,"admin");

select * from login;