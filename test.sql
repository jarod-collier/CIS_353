SPOOL project.out
SET ECHO ON
/*
CIS 353 - Database Design Project
Jarod Collier
Randy Nguyen
Josef Hartsough
Josh Weinmann
Nick Sheehan
*/
--< The SQL/DDL code that creates your schema >
--In the DDL, every IC must have a unique name; e.g. IC5, IC10, IC15, etc.

-- Drop the tables (in case they already exist)
--
--
-- Create the tables
--
DROP TABLE player CASCADE CONSTRAINTS;
DROP TABLE raid CASCADE CONSTRAINTS;
DROP TABLE raid_obstacle CASCADE CONSTRAINTS;
DROP TABLE quests CASCADE CONSTRAINTS;
DROP TABLE accepts CASCADE CONSTRAINTS;
DROP TABLE strike CASCADE CONSTRAINTS;
DROP TABLE planet CASCADE CONSTRAINTS;

CREATE TABLE planet (
  name 		char(40) PRIMARY KEY,
  material 	varchar2(40),
  enemType	varchar2(40)
);
CREATE TABLE raid (
  name		char(40) PRIMARY KEY,
  dfclty	varchar2(40),
  antgnst	varchar2(40),
  sect	varchar2(40),
  recLevel	integer,
  Pname char(40),
  charAmt	integer,
  CONSTRAINT fk_raidToPlanet FOREIGN KEY (Pname) REFERENCES planet(name)
);
CREATE TABLE raid_obstacle (
  name 		char(40),
  obstacle	varchar2(40),
  CONSTRAINT fk_obstacleToRaid FOREIGN KEY (name) REFERENCES raid(name),
  PRIMARY KEY (name, obstacle)
);
CREATE TABLE quests (
  Qname 	char(40),
  Pname 	char(40),
  objective	varchar2(40),
  timer		integer,
  CONSTRAINT fk_questsToPlanet FOREIGN KEY (Pname) REFERENCES planet(name),
  PRIMARY KEY (Qname, Pname)
);
CREATE TABLE accepts (
  username	char(40),
  Pname 	char(40),
  Qname 	char(40),
  PRIMARY KEY (username, Pname, Qname)
);
CREATE TABLE strike (
  name 		char(40) PRIMARY KEY,
  boss		varchar2(40),
  dfclty	varchar2(40),
  pname		varchar2(40),
  charAmt	integer
);
CREATE TABLE player (
  username  char(15) PRIMARY KEY, 
  hp	    integer,
  strength  integer,
  speed		integer,
  lvl	    integer,
  strName	char (40),
  raidName	char(40),
  CONSTRAINT player_strike FOREIGN KEY (strName) REFERENCES strike(name),
  CONSTRAINT player_raid FOREIGN KEY (raidName) REFERENCES raid(name),
/*
IC1: The player's strength and speed cannot sum to be greater than 100.
*/ 
CONSTRAINT IC1 CHECK ((strength + speed) < 101),
/*
IC2: The player's hp must not be positive.
*/
CONSTRAINT IC2 CHECK (hp >= 0)
);
--
SET FEEDBACK OFF
-- < The INSERT statements that populate the tables>
--
-- Add the planets
--
INSERT INTO planet values ('Earth', 'Spin Metal', 'Hive');
INSERT INTO planet values ('Moon', 'Helium Fragments', 'Fallen');
INSERT INTO planet values ('Venus', 'Spirit Bloom' , 'Vex');
INSERT INTO planet values ('Mars', 'Relic Iron', 'Cabal');
--
-- Add the raids
--
insert into raid values ('Vault of Glass', 'Easy', 'Atheon', 'Ishtar Sink', 26, 'Venus', 4);
insert into raid values ('Crota''s End', 'Normal', 'Crota', 'Ocean of Storms', 33, 'Moon', 4);
insert into raid values ('King''s Fall', 'Hard', 'Oryx', 'Dreadnaught', 38, 'Mars', 4);
insert into raid values ('Wrath of the Machine', 'Legendary', 'Aksis', 'Foundary 113', 40, 'Earth', 4);
--
-- Add the raid_sections
--
insert into raid_obstacle values ('Vault of Glass', 'Time''s Conflux');
insert into raid_obstacle values ('Vault of Glass', 'The Spire');
insert into raid_obstacle values ('Vault of Glass', 'The Templar');
insert into raid_obstacle values ('Crota''s End', 'The Bridge');
insert into raid_obstacle values ('Crota''s End', 'The Hellmouth');
insert into raid_obstacle values ('Crota''s End', 'The Stills');
insert into raid_obstacle values ('King''s Fall', 'Hall of Souls');
insert into raid_obstacle values ('King''s Fall', 'The Warpriest');
insert into raid_obstacle values ('King''s Fall', 'Golgoroth''s Cellar');
insert into raid_obstacle values ('Wrath of the Machine', 'Siege Engine');
insert into raid_obstacle values ('Wrath of the Machine', 'Vosik Phase 1');
insert into raid_obstacle values ('Wrath of the Machine', 'Aksis Phase1');

--
-- Add the strikes      
--
INSERT INTO strike values ('The Abomination Heist', 'Hive Abomination', 'Normal', 'Moon', 3);
INSERT INTO strike values ('Fallen Saber', 'SABER 2', 'Easy', 'Earth', 3);
INSERT INTO strike values ('Dust Palace', 'Vatch', 'Normal', 'Mars', 3);
INSERT INTO strike values ('Echo Chamber', 'Theosyion', 'Hard', 'Venus', 3);
INSERT INTO strike values ('Winter''s Run', 'Aksor', 'Hard', 'Venus', 3);
INSERT INTO strike values ('The Undying Mind', 'The Undying Mind', 'Normal', 'Mars', 3);
INSERT INTO strike values ('The Shadow Thief', 'Taniks Perfected', 'Normal', 'Moon', 3);
INSERT INTO strike values ('The Will of Crotia', 'Omnigul', 'Easy', 'Earth', 3);    
-- 
--
-- Add the quests
--
insert into quests values ('Bounty Hunter', 'Earth', 'Eliminate Target',	25);
insert into quests values ('Patrols 101', 'Earth', 'Patrol',	15);
insert into quests values ('The mountaintop', 'Earth', 'Eliminate enemies',	10);
insert into quests values ('High-Value Targets', 'Earth', 'Eliminate Target',	20);
insert into quests values ('A Cry for Help', 'Moon', 'Defend Objective',	10);
insert into quests values ('Retaliation', 'Moon', 'Attack objective',	25);
insert into quests values ('Neverending Battle', 'Venus', 'Eliminate enemies',	30);
insert into quests values ('Back in the Saddle', 'Venus', 'Attack objective',	20);
insert into quests values ('Flameforged', 'Venus', 'Eliminate Target',	20);
insert into quests values ('Successor to the Throne', 'Mars', 'Defend Objective', 25);
insert into quests values ('Conquer the Day', 'Mars', 'Eliminate enemies',	35);
insert into quests values ('Lost and Found', 'Mars', 'Collect Items',	15);

--
-- Add the accepts
--
insert into accepts values ('Farmer', 'Earth', 'Patrols 101');
insert into accepts values ('Butcher', 'Earth', 'Bounty Hunter');
insert into accepts values ('Pawn', 'Earth', 'The mountaintop');
insert into accepts values ('Servant', 'Earth', 'High-Value Targets');
insert into accepts values ('Minion', 'Moon', 'A Cry for Help');
insert into accepts values ('Assassin', 'Moon', 'Retaliation');
insert into accepts values ('Knight', 'Venus', 'Back in the Saddle');
insert into accepts values ('Bishop', 'Venus', 'Neverending Battle');
insert into accepts values ('Lancer', 'Venus', 'Flameforged');
insert into accepts values ('Archer', 'Mars', 'Successor to the Throne');
insert into accepts values ('Rook', 'Mars', 'Conquer the Day');
insert into accepts values ('Ruler', 'Mars', 'Lost and Found');
--
-- 
--
-- Add the players
--
insert into player values ('Farmer', 5, 15, 10, 1, NULL, NULL);
insert into player values ('Butcher', 5, 20, 5, 1, NULL, NULL);
insert into player values ('Pawn', 15, 10, 15, 3, 'The Will of Crotia', NULL);
insert into player values ('Servant', 45, 12, 13, 9, 'The Will of Crotia', NULL);
insert into player values ('Minion', 95, 30, 20, 19, 'The Will of Crotia', 'Vault of Glass');
insert into player values ('Assassin', 110, 20, 55, 22, NULL, 'Vault of Glass');
insert into player values ('Knight', 125, 5, 70, 25, NULL, 'Vault of Glass');
insert into player values ('Bishop', 135, 25, 50, 27, 'Dust Palace', NULL);
insert into player values ('Lancer', 150, 55, 20, 30, NULL, 'Vault of Glass');
insert into player values ('Archer', 165, 50, 50, 33,'Dust Palace', NULL);
insert into player values ('Rook', 180, 50, 50, 36, NULL, 'Crota''s End');
insert into player values ('Ruler', 200, 30, 70, 40, 'Dust Palace',	'Crota''s End');
insert into player values ('Queen', 200, 50, 50, 40, NULL, 'Crota''s End');
insert into player values ('King', 200, 90, 10, 40, NULL, 'Crota''s End');

SET FEEDBACK ON
COMMIT;
--
--
-- ONE QUERY PER TABLE TO PRINT OUT DATABASE
SELECT * FROM player;
SELECT * FROM raid;
SELECT * FROM raid_obstacle;
SELECT * FROM quests;
SELECT * FROM accepts;
SELECT * FROM strike;
SELECT * FROM planet;
--
-- < The SQL queries>. Include the following for each query:
-- 1. A comment line stating the query number and the feature(s) it demonstrates
-- (e.g. – Q25 – correlated subquery).
-- 2. A comment line stating the query in English.
-- 3. The SQL code for the query.
-- --
-- --
-- < The insert/delete/update statements to test the enforcement of ICs >
-- Include the following items for every IC that you test (Important: see the next section titled
-- “Submit a final report” regarding which ICs to test).
-- A comment line stating: Testing: < IC name>
-- A SQL INSERT, DELETE, or UPDATE that will test the IC.
-- Test IC1 that strength and speed is not greater than 100
insert into player values ('Superman' , 1000, 1000, 1000, 40, NULL, NULL);
-- Test IC2 that player's health cannot be negative
insert into player values ('Corpse', -2, 1, 1, 3, NULL, NULL);
-- Test primary key constraint for player table
insert into planet values('Earth', 'Boss', 'Humans');
-- Test foreign key constraint for strike name
insert into player values ('Person' , 1, 10, 10, 4, 'str_name', NULL);

COMMIT;
--

SPOOL OFF
