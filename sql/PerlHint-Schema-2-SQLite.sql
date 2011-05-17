-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Tue May 17 14:56:11 2011
-- 

BEGIN TRANSACTION;

--
-- Table: pattern
--
DROP TABLE pattern;

CREATE TABLE pattern (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  pattern TEXT,
  description TEXT,
  created_date DATETIME NOT NULL,
  updated_date DATETIME NOT NULL
);

--
-- Table: user
--
DROP TABLE user;

CREATE TABLE user (
  id INTEGER PRIMARY KEY NOT NULL,
  name VARCHAR(255) NOT NULL,
  created_date DATETIME NOT NULL,
  updated_date DATETIME NOT NULL
);

COMMIT;
