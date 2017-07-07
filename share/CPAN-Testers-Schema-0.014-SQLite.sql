-- 
-- Created by SQL::Translator::Producer::SQLite
-- Created on Sat May 27 00:18:42 2017
-- 

BEGIN TRANSACTION;

--
-- Table: metabase_user
--
DROP TABLE metabase_user;

CREATE TABLE metabase_user (
  id INTEGER PRIMARY KEY NOT NULL,
  resource char(50) NOT NULL,
  fullname varchar NOT NULL,
  email varchar
);

CREATE UNIQUE INDEX metabase_user_resource ON metabase_user (resource);

--
-- Table: test_report
--
DROP TABLE test_report;

CREATE TABLE test_report (
  id char(36) NOT NULL,
  created datetime NOT NULL,
  report JSON NOT NULL,
  PRIMARY KEY (id)
);

--
-- Table: uploads
--
DROP TABLE uploads;

CREATE TABLE uploads (
  uploadid INTEGER PRIMARY KEY NOT NULL,
  type varchar NOT NULL,
  author varchar NOT NULL,
  dist varchar NOT NULL,
  version varchar NOT NULL,
  filename varchar NOT NULL,
  released bigint NOT NULL
);

--
-- Table: cpanstats
--
DROP TABLE cpanstats;

CREATE TABLE cpanstats (
  id INTEGER PRIMARY KEY NOT NULL,
  guid char(36) NOT NULL,
  state enum NOT NULL,
  postdate mediumint NOT NULL,
  tester varchar(100) NOT NULL,
  dist varchar(100) NOT NULL,
  version varchar(20) NOT NULL,
  platform varchar(20) NOT NULL,
  perl varchar(10) NOT NULL,
  osname varchar(20) NOT NULL,
  osvers varchar(20) NOT NULL,
  fulldate char(8) NOT NULL,
  type tinyint NOT NULL,
  uploadid int NOT NULL,
  FOREIGN KEY (uploadid) REFERENCES uploads(uploadid)
);

CREATE INDEX cpanstats_idx_uploadid ON cpanstats (uploadid);

CREATE UNIQUE INDEX cpanstats_guid ON cpanstats (guid);

--
-- Table: ixlatest
--
DROP TABLE ixlatest;

CREATE TABLE ixlatest (
  dist varchar NOT NULL,
  author varchar NOT NULL,
  version varchar NOT NULL,
  released bigint NOT NULL,
  oncpan int NOT NULL,
  uploadid int NOT NULL,
  PRIMARY KEY (dist, author),
  FOREIGN KEY (uploadid) REFERENCES uploads(uploadid)
);

CREATE INDEX ixlatest_idx_uploadid ON ixlatest (uploadid);

--
-- Table: release_data
--
DROP TABLE release_data;

CREATE TABLE release_data (
  dist varchar NOT NULL,
  version varchar NOT NULL,
  id int NOT NULL,
  guid char(36) NOT NULL,
  oncpan int NOT NULL,
  distmat int NOT NULL,
  perlmat int NOT NULL,
  patched int NOT NULL,
  pass int NOT NULL,
  fail int NOT NULL,
  na int NOT NULL,
  unknown int NOT NULL,
  uploadid int NOT NULL,
  PRIMARY KEY (id, guid),
  FOREIGN KEY (uploadid) REFERENCES uploads(uploadid)
);

CREATE INDEX release_data_idx_uploadid ON release_data (uploadid);

--
-- Table: release_summary
--
DROP TABLE release_summary;

CREATE TABLE release_summary (
  dist varchar NOT NULL,
  version varchar NOT NULL,
  id int NOT NULL,
  guid char(36) NOT NULL,
  oncpan int NOT NULL,
  distmat int NOT NULL,
  perlmat int NOT NULL,
  patched int NOT NULL,
  pass int NOT NULL,
  fail int NOT NULL,
  na int NOT NULL,
  unknown int NOT NULL,
  uploadid int NOT NULL,
  FOREIGN KEY (guid) REFERENCES cpanstats(guid),
  FOREIGN KEY (uploadid) REFERENCES uploads(uploadid)
);

CREATE INDEX release_summary_idx_guid ON release_summary (guid);

CREATE INDEX release_summary_idx_uploadid ON release_summary (uploadid);

COMMIT;