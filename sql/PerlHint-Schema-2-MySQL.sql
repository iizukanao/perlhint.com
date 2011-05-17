-- 
-- Created by SQL::Translator::Producer::MySQL
-- Created on Tue May 17 14:56:11 2011
-- 
SET foreign_key_checks=0;

DROP TABLE IF EXISTS `pattern`;

--
-- Table: `pattern`
--
CREATE TABLE `pattern` (
  `id` INTEGER unsigned NOT NULL auto_increment,
  `name` VARCHAR(255) NOT NULL,
  `pattern` text,
  `description` text,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

DROP TABLE IF EXISTS `user`;

--
-- Table: `user`
--
CREATE TABLE `user` (
  `id` INTEGER unsigned NOT NULL,
  `name` VARCHAR(255) NOT NULL,
  `created_date` datetime NOT NULL,
  `updated_date` datetime NOT NULL,
  PRIMARY KEY (`id`)
) ENGINE=InnoDB DEFAULT CHARACTER SET utf8;

SET foreign_key_checks=1;

