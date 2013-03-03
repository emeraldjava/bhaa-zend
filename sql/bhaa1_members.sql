-- phpMyAdmin SQL Dump
-- version 2.11.9.5
-- http://www.phpmyadmin.net
--
-- Host: localhost
-- Generation Time: Oct 25, 2009 at 10:43 AM
-- Server version: 5.0.77
-- PHP Version: 5.2.6

SET SQL_MODE="NO_AUTO_VALUE_ON_ZERO";


/*!40101 SET @OLD_CHARACTER_SET_CLIENT=@@CHARACTER_SET_CLIENT */;
/*!40101 SET @OLD_CHARACTER_SET_RESULTS=@@CHARACTER_SET_RESULTS */;
/*!40101 SET @OLD_COLLATION_CONNECTION=@@COLLATION_CONNECTION */;
/*!40101 SET NAMES utf8 */;

--
-- Database: `bhaa1_members`
--

-- --------------------------------------------------------

--
-- Table structure for table `company`
--

DROP TABLE IF EXISTS `company`;
CREATE TABLE IF NOT EXISTS `company` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sector` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `division`
--

DROP TABLE IF EXISTS `division`;
CREATE TABLE IF NOT EXISTS `division` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) default NULL,
  `code` varchar(2) default NULL,
  `gender` enum('M','W','T') default 'M',
  `min` int(11) NOT NULL,
  `max` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=9 ;

-- --------------------------------------------------------

--
-- Table structure for table `event`
--

DROP TABLE IF EXISTS `event`;
CREATE TABLE IF NOT EXISTS `event` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(100) NOT NULL,
  `location` varchar(100) NOT NULL,
  `date` date NOT NULL,
  `type` enum('road','cc','beach','track') default NULL,
  `contactPerson` varchar(100) default NULL,
  `racepixs` varchar(20) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=27 ;

-- --------------------------------------------------------

--
-- Table structure for table `league`
--

DROP TABLE IF EXISTS `league`;
CREATE TABLE IF NOT EXISTS `league` (
  `id` int(11) NOT NULL auto_increment,
  `name` varchar(20) default NULL,
  `year` varchar(4) default NULL,
  `type` enum('I','T') default 'I',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=5 ;

-- --------------------------------------------------------

--
-- Table structure for table `leagueevent`
--

DROP TABLE IF EXISTS `leagueevent`;
CREATE TABLE IF NOT EXISTS `leagueevent` (
  `id` int(11) NOT NULL auto_increment,
  `league` int(11) default NULL,
  `event` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=40 ;

-- --------------------------------------------------------

--
-- Table structure for table `leaguerunnerdata`
--

DROP TABLE IF EXISTS `leaguerunnerdata`;
CREATE TABLE IF NOT EXISTS `leaguerunnerdata` (
  `Id` int(11) unsigned NOT NULL auto_increment,
  `league` int(11) unsigned NOT NULL,
  `runner` int(11) unsigned NOT NULL,
  `racesComplete` int(11) unsigned NOT NULL,
  `pointsTotal` double default NULL,
  `avgOverallPosition` double NOT NULL,
  `standard` int(11) default NULL,
  PRIMARY KEY  (`Id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=6666 ;

-- --------------------------------------------------------

--
-- Table structure for table `login`
--

DROP TABLE IF EXISTS `login`;
CREATE TABLE IF NOT EXISTS `login` (
  `id` int(11) NOT NULL auto_increment,
  `runner` int(11) NOT NULL,
  `email` varchar(50) NOT NULL,
  `name` varchar(30) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=4 ;

-- --------------------------------------------------------

--
-- Table structure for table `race`
--

DROP TABLE IF EXISTS `race`;
CREATE TABLE IF NOT EXISTS `race` (
  `id` int(11) NOT NULL auto_increment,
  `event` int(11) NOT NULL,
  `starttime` time NOT NULL,
  `distance` double NOT NULL,
  `unit` enum('KM','Mile') default 'KM',
  `category` varchar(30) default 'Combined',
  `file` varchar(50) default NULL,
  `type` enum('C','W','M') NOT NULL default 'C',
  PRIMARY KEY  (`id`),
  KEY `event` (`event`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=72 ;

-- --------------------------------------------------------

--
-- Table structure for table `RaceOrganiser`
--

DROP TABLE IF EXISTS `RaceOrganiser`;
CREATE TABLE IF NOT EXISTS `RaceOrganiser` (
  `id` int(11) NOT NULL auto_increment,
  `event` int(11) NOT NULL,
  `runner` int(11) NOT NULL,
  `league` int(11) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=74 ;

-- --------------------------------------------------------

--
-- Table structure for table `raceresult`
--

DROP TABLE IF EXISTS `raceresult`;
CREATE TABLE IF NOT EXISTS `raceresult` (
  `race` int(11) NOT NULL,
  `runner` int(11) NOT NULL,
  `racetime` time default NULL,
  `position` int(11) default NULL,
  `racenumber` int(11) default NULL,
  `category` varchar(20) default NULL,
  `standard` int(11) default NULL,
  `paceKM` time default NULL,
  `points` double default NULL,
  `postRaceStandard` int(11) default NULL
) ENGINE=InnoDB DEFAULT CHARSET=latin1;

-- --------------------------------------------------------

--
-- Table structure for table `registration`
--

DROP TABLE IF EXISTS `registration`;
CREATE TABLE IF NOT EXISTS `registration` (
  `id` int(11) NOT NULL auto_increment,
  `event` int(11) default NULL,
  `runner` int(4) default NULL,
  `firstname` varchar(50) NOT NULL,
  `surname` varchar(50) NOT NULL,
  `gender` varchar(1) NOT NULL,
  `dateofbirth` date NOT NULL,
  `address` varchar(50) default NULL,
  `address2` varchar(50) default NULL,
  `address3` varchar(50) default NULL,
  `email` varchar(50) NOT NULL,
  `mobile` varchar(50) NOT NULL,
  `company` int(11) default NULL,
  `sector` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=8 ;

-- --------------------------------------------------------

--
-- Table structure for table `runner`
--

DROP TABLE IF EXISTS `runner`;
CREATE TABLE IF NOT EXISTS `runner` (
  `id` int(11) NOT NULL auto_increment,
  `surname` varchar(30) NOT NULL,
  `firstname` varchar(30) NOT NULL,
  `gender` enum('M','W') NOT NULL default 'M',
  `standard` int(11) default NULL,
  `dateOfBirth` date NOT NULL,
  `company` int(11) default NULL,
  `team` int(11) default NULL,
  `email` varchar(50) NOT NULL,
  `telephone` varchar(50) NOT NULL,
  `address` varchar(50) NOT NULL,
  `status` enum('M','D','I') default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=InnoDB  DEFAULT CHARSET=latin1 AUTO_INCREMENT=10034 ;

-- --------------------------------------------------------

--
-- Table structure for table `sct`
--

DROP TABLE IF EXISTS `sct`;
CREATE TABLE IF NOT EXISTS `sct` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `sector` int(11) NOT NULL,
  `isSector` tinyint(1) NOT NULL,
  `isCompany` tinyint(1) NOT NULL,
  `isSectorTeam` tinyint(1) NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `sector`
--

DROP TABLE IF EXISTS `sector`;
CREATE TABLE IF NOT EXISTS `sector` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `description` varchar(250) NOT NULL,
  `valid` char(1) default 'Y',
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `StandardData`
--

DROP TABLE IF EXISTS `StandardData`;
CREATE TABLE IF NOT EXISTS `StandardData` (
  `id` int(11) NOT NULL auto_increment,
  `standard` int(11) NOT NULL,
  `fourMileTime` time NOT NULL,
  `halfMarathonTime` time NOT NULL,
  `slopeFactor` double NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

-- --------------------------------------------------------

--
-- Table structure for table `standarddata`
--

DROP TABLE IF EXISTS `standarddata`;
CREATE TABLE IF NOT EXISTS `standarddata` (
  `id` int(11) NOT NULL auto_increment,
  `standard` int(11) NOT NULL,
  `fourMileTime` time NOT NULL,
  `halfMarathonTime` time NOT NULL,
  `slopeFactor` double NOT NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM  DEFAULT CHARSET=utf8 AUTO_INCREMENT=32 ;

-- --------------------------------------------------------

--
-- Table structure for table `team`
--

DROP TABLE IF EXISTS `team`;
CREATE TABLE IF NOT EXISTS `team` (
  `id` int(11) NOT NULL,
  `name` varchar(50) NOT NULL,
  `type` enum('C','S') NOT NULL,
  `company` int(11) default NULL,
  `sector` int(11) NOT NULL,
  `contact` int(11) default NULL,
  PRIMARY KEY  (`id`)
) ENGINE=MyISAM DEFAULT CHARSET=utf8;

-- --------------------------------------------------------

--
-- Table structure for table `teammember`
--

DROP TABLE IF EXISTS `teammember`;
CREATE TABLE IF NOT EXISTS `teammember` (
  `team` int(11) NOT NULL,
  `runner` int(11) NOT NULL
) ENGINE=MyISAM DEFAULT CHARSET=utf8;
