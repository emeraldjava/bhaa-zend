CREATE TABLE `eventexception` (
  `id` int(11) NOT NULL AUTO_INCREMENT,
  `event` int(11) NOT NULL,
  `runner` int(11) NOT NULL,
  `exceptiontype` int(11) NOT NULL,
  PRIMARY KEY (`id`)
);