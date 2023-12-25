--   DATABASES 2018
--   (c) Bernhard Reus, University of Sussex
--   21.11.2019
--   ASSIGNMENT 2 set up file

-- This file must be run before you answer the questions of the 2nd assignment.
-- Do not include this code or parts of it in your submission.

DROP FUNCTION IF EXISTS totalRaceTime;

DROP TABLE IF EXISTS MoSpo_HallOfFame;
DROP TABLE IF EXISTS MoSpo_PitStop;
DROP TABLE IF EXISTS MoSpo_LapInfo;
DROP TABLE IF EXISTS MoSpo_RaceEntry;
DROP TABLE IF EXISTS MoSpo_Car;
DROP TABLE IF EXISTS MoSpo_Driver;
DROP TABLE IF EXISTS MoSpo_RacingTeam;
DROP TABLE IF EXISTS MoSpo_Lap;
DROP TABLE IF EXISTS MoSpo_Race;
DROP TABLE IF EXISTS MoSpo_RaceCourse;


-- TABLE DEFINITIONS ---


CREATE TABLE MoSpo_RaceCourse (
raceCourseName VARCHAR(30) PRIMARY KEY,
raceCourseLocation VARCHAR(30),
raceCourseLength DEC(5,3) UNSIGNED
);


CREATE TABLE MoSpo_Race (
raceName VARCHAR(30),
raceDate DATE,
raceTime TIME,
raceVenue VARCHAR(30),
raceLaps TINYINT UNSIGNED,
PRIMARY KEY (raceName,raceDate),
CONSTRAINT MoSpo_Race_Location 
FOREIGN KEY (raceVenue) REFERENCES MoSpo_RaceCourse(raceCourseName)
);


CREATE TABLE MoSpo_Lap (
lapNo TINYINT UNSIGNED,
lapRaceName VARCHAR(30),
lapRaceDate DATE,
CONSTRAINT MoSpo_Lap_Race
FOREIGN KEY (lapRaceName,lapRaceDate) REFERENCES MoSpo_Race(raceName, raceDate),
PRIMARY KEY(lapNo,lapRaceName,lapRaceDate)
);



CREATE TABLE MoSpo_RacingTeam (
teamName VARCHAR(30) primary key,
teamPostcode CHAR(9),
teamStreet VARCHAR(30),
teamHouseNo CHAR(4)
);


CREATE TABLE MoSpo_Driver(
driverId INTEGER UNSIGNED  PRIMARY KEY,
driverDOB DATE,
driverLastname VARCHAR(30),
driverFirstname VARCHAR(30),
driverNationality VARCHAR(20),
driverTeam VARCHAR(30),
CONSTRAINT MoSpo_Driver_Team
FOREIGN KEY (driverTeam) REFERENCES MoSpo_RacingTeam(teamName)
);

 
CREATE TABLE MoSpo_Car(
carId INTEGER UNSIGNED PRIMARY KEY,
carMake VARCHAR(30),
carTeam VARCHAR(30),
CONSTRAINT MoSpo_Car_Team
FOREIGN KEY (carTeam) REFERENCES MoSpo_RacingTeam(teamName)
);


CREATE TABLE MoSpo_RaceEntry(
raceEntryNumber TINYINT UNSIGNED,
raceEntryRaceName VARCHAR(30),
raceEntryRaceDate DATE,
raceEntryDriverId INTEGER UNSIGNED NOT NULL,
raceEntryCarId INTEGER UNSIGNED NOT NULL,
raceEntryTyreType ENUM('soft','hard','wet','intermediate','medium','super-soft'),
PRIMARY KEY (raceEntryNumber,raceEntryRaceName,raceEntryRaceDate),
CONSTRAINT MoSpo_RaceEntry_Race
 FOREIGN KEY (raceEntryRaceName,raceEntryRaceDate) REFERENCES MoSpo_Race(raceName,raceDate),
 CONSTRAINT MoSpo_RaceEntry_Driver
FOREIGN KEY (raceEntryDriverId) REFERENCES MoSpo_Driver(driverId),
CONSTRAINT MoSpo_RaceEntry_Car
FOREIGN KEY (raceEntryCarId) REFERENCES MoSpo_Car(carId)
);

 
CREATE TABLE MoSpo_LapInfo  (
lapInfoLapNo TINYINT UNSIGNED,
lapInfoRaceName  VARCHAR(30),
lapInfoRaceDate DATE,
lapInfoRaceNumber TINYINT UNSIGNED,
lapInfoFuelConsumption DECIMAL(4,2),
lapInfoTime INT UNSIGNED, -- milliseconds
lapInfoCompleted TINYINT UNSIGNED NOT NULL  DEFAULT 1,
PRIMARY KEY (lapInfoLapNo, lapInfoRaceName, lapInfoRaceDate, lapInfoRaceNumber),
CONSTRAINT MoSpo_LapInfo2_Lap
FOREIGN KEY (lapInfoLapNo, lapInfoRaceName, lapInfoRaceDate) REFERENCES MoSpo_Lap(lapNo,lapRaceName,lapRaceDate),
CONSTRAINT MoSpo_LapInfo2_Car
FOREIGN KEY (lapInfoRaceNumber, lapInfoRaceName, lapInfoRaceDate) REFERENCES MoSpo_RaceEntry(raceEntryNumber, raceEntryRaceName,raceEntryRaceDate)
);



CREATE TABLE MoSpo_PitStop  (
pitstopLapNo TINYINT UNSIGNED,
pitstopRaceName  VARCHAR(30),
pitstopRaceDate DATE,
pitstopRaceNumber TINYINT UNSIGNED,
pitstopDuration INT UNSIGNED,  -- milliseconds
pitstopChangedParts SET('front_wing','rear_wing','nose','steering','suspension','shock_absorber','tyre'),
PRIMARY KEY (pitstopLapNo, pitstopRaceName, pitstopRaceDate, pitstopRaceNumber),
CONSTRAINT MoSpo_PitStop2_Lap
FOREIGN KEY (pitstopLapNo, pitstopRaceName, pitstopRaceDate) REFERENCES MoSpo_Lap(lapNo,lapRaceName,lapRaceDate),
CONSTRAINT MoSpo_PitStop2_Car
FOREIGN KEY (pitstopRaceNumber, pitstopRaceName, pitstopRaceDate) REFERENCES MoSpo_RaceEntry(raceEntryNumber, raceEntryRaceName,raceEntryRaceDate)
);

 
-- Some sample data


INSERT INTO MoSpo_RaceCourse VALUES
('Autodromo Nazionale Monza','Monza',3.6),
('Silverstone Circuit','Silverstone',3.667),
('Nürburgring','Nürburg',5.148),
('Hockenheimring','Hockenheim',2.842);

INSERT INTO MoSpo_Race VALUES
('German Grand Prix','2018-07-20','14:00:00','Hockenheimring',60),
('German Grand Prix','2017-07-07','14:00:00','Nürburgring',60),
('German Grand Prix','2016-07-06','14:00:00','Nürburgring',60),
('British Grand Prix','2017-06-30','13:00:00','Silverstone Circuit',52),
('British Grand Prix','2018-07-06','13:00:00','Silverstone Circuit',52),
('British Grand Prix','2016-07-05','13:00:00','Silverstone Circuit',52),
('British GT Championship','2018-06-01','15:00:00','Silverstone Circuit',52),
('British GT Championship','2017-06-02','15:00:00','Silverstone Circuit',52),
('Italian Grand Prix','2018-09-07','13:00:00','Autodromo Nazionale Monza',67);


INSERT INTO MoSpo_RacingTeam VALUES 
('Mercedes AMG F1','NN137BD','Main Street','1'),
('Ferrari','I-41043','Via Abeto Inferiore','4'),
('Aston Martin Racing','OX163ER','Racing Avenue','100A'),
('Beechdean Motorsport','HP144NL','North Dean','35'),
('Williams Martini Racing','OX120DQ','Wantage Road','1'),
('Infiniti Red Bull Racing','MK78BJ','Bradbourne Drive','2B'),
('Geoff Steel Racing','DN214BD','Station Road',NULL),
('BMW DTM','D-566521','Brohlahtstrasse','60');
 

INSERT INTO MoSpo_Driver VALUES 
(10,'1987-07-03','Vettel','Sebastian','German', 'Ferrari'),
(20,'1989-07-01','Ricciardo','Daniel','Australian', 'Infiniti Red Bull Racing'),
(30,'1985-06-27','Rosberg','Nico','German', 'Mercedes AMG F1'),
(40,'1985-01-07','Hamilton','Lewis','British', 'Mercedes AMG F1'),
(50,'1983-10-15','Senna','Bruno','Brazilian', 'Ferrari'),
(100,'1982-12-06','Wolff','Susie','British','Williams Martini Racing'),
(103,'1960-05-01','Hamilton', 'Lewis','British', 'Beechdean Motorsport'),
(1030,'1991-09-22','Hamilton', 'Mike','Irish', 'Beechdean Motorsport'),
(60,'1993-01-26','Powell','Alice','British','Aston Martin Racing'),
(22,'1992-01-02','Eaton','Abbie','British','Geoff Steel Racing'),
(42,'1969-05-14','Schmitz','Sabine','German','BMW DTM');


INSERT INTO MoSpo_Car VALUES 
(1,'Renault','Infiniti Red Bull Racing'),
(4,'Renault','Infiniti Red Bull Racing'),
(9,'Mercedes','Mercedes AMG F1'),
(92,'Mercedes','Mercedes AMG F1'),
(93,'Mercedes','Mercedes AMG F1'),
(22,'Porsche','Beechdean Motorsport'),
(12,'BMW','Beechdean Motorsport'),
(13,'BMW','BMW DTM'),
(14,'BMW','BMW DTM'),
(20,'Lotus','Geoff Steel Racing'),
(100,'BMW','Geoff Steel Racing'),
(63,'BMW','Geoff Steel Racing'),
(99,'Aston Martin','Aston Martin Racing');
 

INSERT INTO MoSpo_RaceEntry VALUES 
(5,'German Grand Prix','2018-07-20',10,1,'soft'),
(3,'German Grand Prix','2018-07-20',20,4,'soft'),
(6,'German Grand Prix','2016-07-06',30,92,'soft'),
(5,'German Grand Prix','2016-07-06',10,1,'super-soft'),
(44,'German Grand Prix','2018-07-20',40,93,'super-soft'),
(5,'British Grand Prix','2018-07-06',10,1,'medium'),
(3,'British Grand Prix','2018-07-06',20,4,'medium'),
(6,'British Grand Prix','2016-07-05',30,92,'medium'),
(44,'British Grand Prix','2018-07-06',40,93,'medium'),
(1,'British GT Championship','2018-06-01',103,22,'medium'),
(1,'British GT Championship','2017-06-02',1030,22,'medium'),
(3,'Italian Grand Prix','2018-09-07',20,4,'soft'),
(5,'Italian Grand Prix','2018-09-07',10,1,'super-soft'),
(1,'Italian Grand Prix','2018-09-07',103,12,'medium');

 

 
INSERT INTO MoSpo_Lap VALUES (1,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (2,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (3,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (4,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (5,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (6,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (7,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (8,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (9,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (10,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (11,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (12,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (13,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (14,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (15,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (16,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (17,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (18,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (19,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (20,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (21,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (22,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (23,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (24,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (25,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (26,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (27,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (28,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (29,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (30,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (31,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (32,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (33,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (34,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (35,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (36,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (37,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (38,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (39,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (40,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (41,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (42,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (43,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (44,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (45,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (46,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (47,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (48,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (49,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (50,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (51,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (52,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (53,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (54,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (55,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (56,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (57,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (58,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (59,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (60,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (61,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (62,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (63,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (64,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (65,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (66,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_Lap VALUES (67,'German Grand Prix','2018-07-20');
INSERT INTO MoSpo_LapInfo  VALUES (1,'German Grand Prix','2018-07-20',5,8.3,92001,1);
INSERT INTO MoSpo_LapInfo  VALUES (2,'German Grand Prix','2018-07-20',5,8.3,91002,1);
INSERT INTO MoSpo_LapInfo  VALUES (3,'German Grand Prix','2018-07-20',5,8.3,91003,1);
INSERT INTO MoSpo_LapInfo  VALUES (4,'German Grand Prix','2018-07-20',5,8.3,90004,1);
INSERT INTO MoSpo_LapInfo  VALUES (5,'German Grand Prix','2018-07-20',5,8.1,62005,1);
INSERT INTO MoSpo_LapInfo  VALUES (6,'German Grand Prix','2018-07-20',5,8.3,89000,1);
INSERT INTO MoSpo_LapInfo  VALUES (7,'German Grand Prix','2018-07-20',5,8.3,89001,1);
INSERT INTO MoSpo_LapInfo  VALUES (8,'German Grand Prix','2018-07-20',5,8.3,88002,1);
INSERT INTO MoSpo_LapInfo  VALUES (9,'German Grand Prix','2018-07-20',5,8.3,88003,1);
INSERT INTO MoSpo_LapInfo  VALUES (10,'German Grand Prix','2018-07-20',5,8.1,65004,1);
INSERT INTO MoSpo_LapInfo  VALUES (11,'German Grand Prix','2018-07-20',5,8.3,87005,1);
INSERT INTO MoSpo_LapInfo  VALUES (12,'German Grand Prix','2018-07-20',5,8.3,86000,1);
INSERT INTO MoSpo_LapInfo  VALUES (13,'German Grand Prix','2018-07-20',5,8.3,86001,1);
INSERT INTO MoSpo_LapInfo  VALUES (14,'German Grand Prix','2018-07-20',5,8.3,85002,1);
INSERT INTO MoSpo_LapInfo  VALUES (15,'German Grand Prix','2018-07-20',5,8.1,67003,1);
INSERT INTO MoSpo_LapInfo  VALUES (16,'German Grand Prix','2018-07-20',5,8.3,84004,1);
INSERT INTO MoSpo_LapInfo  VALUES (17,'German Grand Prix','2018-07-20',5,8.3,84005,1);
INSERT INTO MoSpo_LapInfo  VALUES (18,'German Grand Prix','2018-07-20',5,8.3,83000,1);
INSERT INTO MoSpo_LapInfo  VALUES (19,'German Grand Prix','2018-07-20',5,8.3,83001,1);
INSERT INTO MoSpo_LapInfo  VALUES (20,'German Grand Prix','2018-07-20',5,8.1,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES (21,'German Grand Prix','2018-07-20',5,8.3,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (22,'German Grand Prix','2018-07-20',5,8.3,81004,1);
INSERT INTO MoSpo_LapInfo  VALUES (23,'German Grand Prix','2018-07-20',5,8.3,81005,1);
INSERT INTO MoSpo_LapInfo  VALUES (24,'German Grand Prix','2018-07-20',5,8.3,80000,1);
INSERT INTO MoSpo_LapInfo  VALUES (25,'German Grand Prix','2018-07-20',5,8.1,72001,1);
INSERT INTO MoSpo_LapInfo  VALUES (26,'German Grand Prix','2018-07-20',5,8.3,79002,1);
INSERT INTO MoSpo_LapInfo  VALUES (27,'German Grand Prix','2018-07-20',5,8.3,79003,1);
INSERT INTO MoSpo_LapInfo  VALUES (28,'German Grand Prix','2018-07-20',5,8.3,78004,1);
INSERT INTO MoSpo_LapInfo  VALUES (29,'German Grand Prix','2018-07-20',5,8.3,78005,1);
INSERT INTO MoSpo_LapInfo  VALUES (30,'German Grand Prix','2018-07-20',5,8.1,75000,1);
INSERT INTO MoSpo_LapInfo  VALUES (31,'German Grand Prix','2018-07-20',5,8.3,77001,1);
INSERT INTO MoSpo_LapInfo  VALUES (32,'German Grand Prix','2018-07-20',5,8.3,76002,1);
INSERT INTO MoSpo_LapInfo  VALUES (33,'German Grand Prix','2018-07-20',5,8.3,76003,1);
INSERT INTO MoSpo_LapInfo  VALUES (34,'German Grand Prix','2018-07-20',5,8.3,75004,1);
INSERT INTO MoSpo_LapInfo  VALUES (35,'German Grand Prix','2018-07-20',5,8.1,77005,1);
INSERT INTO MoSpo_LapInfo  VALUES (36,'German Grand Prix','2018-07-20',5,8.3,74000,1);
INSERT INTO MoSpo_LapInfo  VALUES (37,'German Grand Prix','2018-07-20',5,8.3,74001,1);
INSERT INTO MoSpo_LapInfo  VALUES (38,'German Grand Prix','2018-07-20',5,8.3,73002,1);
INSERT INTO MoSpo_LapInfo  VALUES (39,'German Grand Prix','2018-07-20',5,8.3,73003,1);
INSERT INTO MoSpo_LapInfo  VALUES (40,'German Grand Prix','2018-07-20',5,8.1,80004,1);
INSERT INTO MoSpo_LapInfo  VALUES (41,'German Grand Prix','2018-07-20',5,8.3,72005,1);
INSERT INTO MoSpo_LapInfo  VALUES (42,'German Grand Prix','2018-07-20',5,8.3,71000,1);
INSERT INTO MoSpo_LapInfo  VALUES (43,'German Grand Prix','2018-07-20',5,8.3,71001,1);
INSERT INTO MoSpo_LapInfo  VALUES (44,'German Grand Prix','2018-07-20',5,8.3,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES (45,'German Grand Prix','2018-07-20',5,8.1,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (46,'German Grand Prix','2018-07-20',5,8.3,69004,1);
INSERT INTO MoSpo_LapInfo  VALUES (47,'German Grand Prix','2018-07-20',5,8.3,69005,1);
INSERT INTO MoSpo_LapInfo  VALUES (48,'German Grand Prix','2018-07-20',5,8.3,68000,1);
INSERT INTO MoSpo_LapInfo  VALUES (49,'German Grand Prix','2018-07-20',5,8.3,68001,1);
INSERT INTO MoSpo_LapInfo  VALUES (50,'German Grand Prix','2018-07-20',5,8.1,85002,1);
INSERT INTO MoSpo_LapInfo  VALUES (51,'German Grand Prix','2018-07-20',5,8.3,67003,1);
INSERT INTO MoSpo_LapInfo  VALUES (52,'German Grand Prix','2018-07-20',5,8.3,66004,1);
INSERT INTO MoSpo_LapInfo  VALUES (53,'German Grand Prix','2018-07-20',5,8.3,66005,1);
INSERT INTO MoSpo_LapInfo  VALUES (54,'German Grand Prix','2018-07-20',5,8.3,65000,1);
INSERT INTO MoSpo_LapInfo  VALUES (55,'German Grand Prix','2018-07-20',5,8.1,87001,1);
INSERT INTO MoSpo_LapInfo  VALUES (56,'German Grand Prix','2018-07-20',5,8.3,64002,1);
INSERT INTO MoSpo_LapInfo  VALUES (57,'German Grand Prix','2018-07-20',5,8.3,64003,1);
INSERT INTO MoSpo_LapInfo  VALUES (58,'German Grand Prix','2018-07-20',5,8.3,63004,1);
INSERT INTO MoSpo_LapInfo  VALUES (59,'German Grand Prix','2018-07-20',5,8.3,63005,1);
INSERT INTO MoSpo_LapInfo  VALUES (60,'German Grand Prix','2018-07-20',5,8.1,90000,1);
INSERT INTO MoSpo_LapInfo  VALUES (61,'German Grand Prix','2018-07-20',5,8.3,62001,1);
INSERT INTO MoSpo_LapInfo  VALUES (62,'German Grand Prix','2018-07-20',5,8.3,61002,1);
INSERT INTO MoSpo_LapInfo  VALUES (63,'German Grand Prix','2018-07-20',5,8.3,61003,1);
INSERT INTO MoSpo_LapInfo  VALUES (64,'German Grand Prix','2018-07-20',5,8.3,60004,1);
INSERT INTO MoSpo_LapInfo  VALUES (65,'German Grand Prix','2018-07-20',5,8.1,92005,1);
INSERT INTO MoSpo_LapInfo  VALUES (66,'German Grand Prix','2018-07-20',5,8.3,59000,1);
INSERT INTO MoSpo_LapInfo  VALUES (67,'German Grand Prix','2018-07-20',5,8.3,59001,1);
INSERT INTO MoSpo_LapInfo  VALUES (1,'German Grand Prix','2018-07-20',44,8.3,92001,1);
INSERT INTO MoSpo_LapInfo  VALUES (2,'German Grand Prix','2018-07-20',44,8.3,91002,1);
INSERT INTO MoSpo_LapInfo  VALUES (3,'German Grand Prix','2018-07-20',44,8.3,91003,1);
INSERT INTO MoSpo_LapInfo  VALUES (4,'German Grand Prix','2018-07-20',44,8.3,90004,1);
INSERT INTO MoSpo_LapInfo  VALUES (5,'German Grand Prix','2018-07-20',44,8.1,62005,1);
INSERT INTO MoSpo_LapInfo  VALUES (6,'German Grand Prix','2018-07-20',44,8.3,89000,1);
INSERT INTO MoSpo_LapInfo  VALUES (7,'German Grand Prix','2018-07-20',44,8.3,89001,1);
INSERT INTO MoSpo_LapInfo  VALUES (8,'German Grand Prix','2018-07-20',44,8.3,88002,1);
INSERT INTO MoSpo_LapInfo  VALUES (9,'German Grand Prix','2018-07-20',44,8.3,88003,1);
INSERT INTO MoSpo_LapInfo  VALUES (10,'German Grand Prix','2018-07-20',44,8.1,65004,1);
INSERT INTO MoSpo_LapInfo  VALUES (11,'German Grand Prix','2018-07-20',44,8.3,87005,1);
INSERT INTO MoSpo_LapInfo  VALUES (12,'German Grand Prix','2018-07-20',44,8.3,86000,1);
INSERT INTO MoSpo_LapInfo  VALUES (13,'German Grand Prix','2018-07-20',44,8.3,86001,1);
INSERT INTO MoSpo_LapInfo  VALUES (14,'German Grand Prix','2018-07-20',44,8.3,85002,1);
INSERT INTO MoSpo_LapInfo  VALUES (15,'German Grand Prix','2018-07-20',44,8.1,67003,1);
INSERT INTO MoSpo_LapInfo  VALUES (16,'German Grand Prix','2018-07-20',44,8.3,84004,1);
INSERT INTO MoSpo_LapInfo  VALUES (17,'German Grand Prix','2018-07-20',44,8.3,84005,1);
INSERT INTO MoSpo_LapInfo  VALUES (18,'German Grand Prix','2018-07-20',44,8.3,83000,1);
INSERT INTO MoSpo_LapInfo  VALUES (19,'German Grand Prix','2018-07-20',44,8.3,83001,1);
INSERT INTO MoSpo_LapInfo  VALUES (20,'German Grand Prix','2018-07-20',44,8.1,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES (21,'German Grand Prix','2018-07-20',44,8.3,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (22,'German Grand Prix','2018-07-20',44,8.3,81004,1);
INSERT INTO MoSpo_LapInfo  VALUES (23,'German Grand Prix','2018-07-20',44,8.3,81005,1);
INSERT INTO MoSpo_LapInfo  VALUES (24,'German Grand Prix','2018-07-20',44,8.3,80000,1);
INSERT INTO MoSpo_LapInfo  VALUES (25,'German Grand Prix','2018-07-20',44,8.1,72001,1);
INSERT INTO MoSpo_LapInfo  VALUES (26,'German Grand Prix','2018-07-20',44,8.3,79002,1);
INSERT INTO MoSpo_LapInfo  VALUES (27,'German Grand Prix','2018-07-20',44,8.3,79003,1);
INSERT INTO MoSpo_LapInfo  VALUES (28,'German Grand Prix','2018-07-20',44,8.3,78004,1);
INSERT INTO MoSpo_LapInfo  VALUES (29,'German Grand Prix','2018-07-20',44,8.3,78005,1);
INSERT INTO MoSpo_LapInfo  VALUES (30,'German Grand Prix','2018-07-20',44,8.1,75000,1);
INSERT INTO MoSpo_LapInfo  VALUES (31,'German Grand Prix','2018-07-20',44,8.3,77001,1);
INSERT INTO MoSpo_LapInfo  VALUES (32,'German Grand Prix','2018-07-20',44,8.3,76002,1);
INSERT INTO MoSpo_LapInfo  VALUES (33,'German Grand Prix','2018-07-20',44,8.3,76003,1);
INSERT INTO MoSpo_LapInfo  VALUES (34,'German Grand Prix','2018-07-20',44,8.3,75004,1);
INSERT INTO MoSpo_LapInfo  VALUES (35,'German Grand Prix','2018-07-20',44,8.1,77005,1);
INSERT INTO MoSpo_LapInfo  VALUES (36,'German Grand Prix','2018-07-20',44,8.3,74000,1);
INSERT INTO MoSpo_LapInfo  VALUES (37,'German Grand Prix','2018-07-20',44,8.3,74001,1);
INSERT INTO MoSpo_LapInfo  VALUES (38,'German Grand Prix','2018-07-20',44,8.3,73002,1);
INSERT INTO MoSpo_LapInfo  VALUES (39,'German Grand Prix','2018-07-20',44,8.3,73003,1);
INSERT INTO MoSpo_LapInfo  VALUES (40,'German Grand Prix','2018-07-20',44,8.1,80004,1);
INSERT INTO MoSpo_LapInfo  VALUES (41,'German Grand Prix','2018-07-20',44,8.3,72005,1);
INSERT INTO MoSpo_LapInfo  VALUES (42,'German Grand Prix','2018-07-20',44,8.3,71000,1);
INSERT INTO MoSpo_LapInfo  VALUES (43,'German Grand Prix','2018-07-20',44,8.3,71001,1);
INSERT INTO MoSpo_LapInfo  VALUES (44,'German Grand Prix','2018-07-20',44,8.3,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES (45,'German Grand Prix','2018-07-20',44,8.1,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (46,'German Grand Prix','2018-07-20',44,8.3,69004,1);
INSERT INTO MoSpo_LapInfo  VALUES (47,'German Grand Prix','2018-07-20',44,8.3,69005,1);
INSERT INTO MoSpo_LapInfo  VALUES (48,'German Grand Prix','2018-07-20',44,8.3,68000,1);
INSERT INTO MoSpo_LapInfo  VALUES (49,'German Grand Prix','2018-07-20',44,8.3,68001,1);
INSERT INTO MoSpo_LapInfo  VALUES (50,'German Grand Prix','2018-07-20',44,8.1,85002,1);
INSERT INTO MoSpo_LapInfo  VALUES (51,'German Grand Prix','2018-07-20',44,8.3,67003,1);
INSERT INTO MoSpo_LapInfo  VALUES (52,'German Grand Prix','2018-07-20',44,8.3,66004,1);
INSERT INTO MoSpo_LapInfo  VALUES (53,'German Grand Prix','2018-07-20',44,8.3,66005,1);
INSERT INTO MoSpo_LapInfo  VALUES (54,'German Grand Prix','2018-07-20',44,8.3,65000,1);
INSERT INTO MoSpo_LapInfo  VALUES (55,'German Grand Prix','2018-07-20',44,8.1,87001,1);
INSERT INTO MoSpo_LapInfo  VALUES (56,'German Grand Prix','2018-07-20',44,8.3,64002,1);
INSERT INTO MoSpo_LapInfo  VALUES (57,'German Grand Prix','2018-07-20',44,8.3,64003,1);
INSERT INTO MoSpo_LapInfo  VALUES (58,'German Grand Prix','2018-07-20',44,8.3,63004,1);
INSERT INTO MoSpo_LapInfo  VALUES (59,'German Grand Prix','2018-07-20',44,8.3,63005,1);
INSERT INTO MoSpo_LapInfo  VALUES (60,'German Grand Prix','2018-07-20',44,8.1,90000,1);
INSERT INTO MoSpo_LapInfo  VALUES (61,'German Grand Prix','2018-07-20',44,8.3,62001,1);
INSERT INTO MoSpo_LapInfo  VALUES (62,'German Grand Prix','2018-07-20',44,8.3,61002,1);
INSERT INTO MoSpo_LapInfo  VALUES (63,'German Grand Prix','2018-07-20',44,8.3,61003,1);
INSERT INTO MoSpo_LapInfo  VALUES (64,'German Grand Prix','2018-07-20',44,8.3,60004,1);
INSERT INTO MoSpo_LapInfo  VALUES (65,'German Grand Prix','2018-07-20',44,8.1,92005,1);
INSERT INTO MoSpo_LapInfo  VALUES (66,'German Grand Prix','2018-07-20',44,8.3,59000,1);
INSERT INTO MoSpo_LapInfo  VALUES (67,'German Grand Prix','2018-07-20',44,8.3,59001,1);
INSERT INTO MoSpo_Lap VALUES (1,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (2,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (3,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (4,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (5,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (6,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (7,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (8,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (9,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (10,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (11,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (12,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (13,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (14,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (15,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (16,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (17,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (18,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (19,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (20,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (21,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (22,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (23,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (24,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (25,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (26,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (27,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (28,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (29,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (30,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (31,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (32,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (33,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (34,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (35,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (36,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (37,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (38,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (39,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (40,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (41,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (42,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (43,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (44,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (45,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (46,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (47,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (48,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (49,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (50,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (51,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (52,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (53,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (54,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (55,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (56,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (57,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (58,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (59,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_Lap VALUES (60,'German Grand Prix','2016-07-06');
INSERT INTO MoSpo_LapInfo  VALUES(1,'German Grand Prix','2016-07-06',6,8.2,97001,1);
INSERT INTO MoSpo_LapInfo  VALUES(2,'German Grand Prix','2016-07-06',6,8.2,96002,1);
INSERT INTO MoSpo_LapInfo  VALUES(3,'German Grand Prix','2016-07-06',6,8.2,96003,1);
INSERT INTO MoSpo_LapInfo  VALUES (4,'German Grand Prix','2016-07-06',6,7.8,61004,1);
INSERT INTO MoSpo_LapInfo  VALUES(5,'German Grand Prix','2016-07-06',6,8.2,95005,1);
INSERT INTO MoSpo_LapInfo  VALUES(6,'German Grand Prix','2016-07-06',6,8.2,94006,1);
INSERT INTO MoSpo_LapInfo  VALUES(7,'German Grand Prix','2016-07-06',6,8.2,94000,1);
INSERT INTO MoSpo_LapInfo  VALUES (8,'German Grand Prix','2016-07-06',6,7.8,62002,1);
INSERT INTO MoSpo_LapInfo  VALUES(9,'German Grand Prix','2016-07-06',6,8.2,93002,1);
INSERT INTO MoSpo_LapInfo  VALUES(10,'German Grand Prix','2016-07-06',6,8.2,92003,1);
INSERT INTO MoSpo_LapInfo  VALUES(11,'German Grand Prix','2016-07-06',6,8.2,92004,1);
INSERT INTO MoSpo_LapInfo  VALUES (12,'German Grand Prix','2016-07-06',6,7.8,64000,1);
INSERT INTO MoSpo_LapInfo  VALUES(13,'German Grand Prix','2016-07-06',6,8.2,91006,1);
INSERT INTO MoSpo_LapInfo  VALUES(14,'German Grand Prix','2016-07-06',6,8.2,90000,1);
INSERT INTO MoSpo_LapInfo  VALUES(15,'German Grand Prix','2016-07-06',6,8.2,90001,1);
INSERT INTO MoSpo_LapInfo  VALUES (16,'German Grand Prix','2016-07-06',6,7.8,65004,1);
INSERT INTO MoSpo_LapInfo  VALUES(17,'German Grand Prix','2016-07-06',6,8.2,89003,1);
INSERT INTO MoSpo_LapInfo  VALUES(18,'German Grand Prix','2016-07-06',6,8.2,88004,1);
INSERT INTO MoSpo_LapInfo  VALUES(19,'German Grand Prix','2016-07-06',6,8.2,88005,1);
INSERT INTO MoSpo_LapInfo  VALUES (20,'German Grand Prix','2016-07-06',6,7.8,66002,1);
INSERT INTO MoSpo_LapInfo  VALUES(21,'German Grand Prix','2016-07-06',6,8.2,87000,1);
INSERT INTO MoSpo_LapInfo  VALUES(22,'German Grand Prix','2016-07-06',6,8.2,86001,1);
INSERT INTO MoSpo_LapInfo  VALUES(23,'German Grand Prix','2016-07-06',6,8.2,86002,1);
INSERT INTO MoSpo_LapInfo  VALUES (24,'German Grand Prix','2016-07-06',6,7.8,68000,1);
INSERT INTO MoSpo_LapInfo  VALUES(25,'German Grand Prix','2016-07-06',6,8.2,85004,1);
INSERT INTO MoSpo_LapInfo  VALUES(26,'German Grand Prix','2016-07-06',6,8.2,84005,1);
INSERT INTO MoSpo_LapInfo  VALUES(27,'German Grand Prix','2016-07-06',6,8.2,84006,1);
INSERT INTO MoSpo_LapInfo  VALUES (28,'German Grand Prix','2016-07-06',6,7.8,69004,1);
INSERT INTO MoSpo_LapInfo  VALUES(29,'German Grand Prix','2016-07-06',6,8.2,83001,1);
INSERT INTO MoSpo_LapInfo  VALUES(30,'German Grand Prix','2016-07-06',6,8.2,82002,1);
INSERT INTO MoSpo_LapInfo  VALUES(31,'German Grand Prix','2016-07-06',6,8.2,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (32,'German Grand Prix','2016-07-06',6,7.8,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES(33,'German Grand Prix','2016-07-06',6,8.2,81005,1);
INSERT INTO MoSpo_LapInfo  VALUES(34,'German Grand Prix','2016-07-06',6,8.2,80006,1);
INSERT INTO MoSpo_LapInfo  VALUES(35,'German Grand Prix','2016-07-06',6,8.2,80000,1);
INSERT INTO MoSpo_LapInfo  VALUES (36,'German Grand Prix','2016-07-06',6,7.8,72000,1);
INSERT INTO MoSpo_LapInfo  VALUES(37,'German Grand Prix','2016-07-06',6,8.2,79002,1);
INSERT INTO MoSpo_LapInfo  VALUES(38,'German Grand Prix','2016-07-06',6,8.2,78003,1);
INSERT INTO MoSpo_LapInfo  VALUES(39,'German Grand Prix','2016-07-06',6,8.2,78004,1);
INSERT INTO MoSpo_LapInfo  VALUES (40,'German Grand Prix','2016-07-06',6,7.8,73004,1);
INSERT INTO MoSpo_LapInfo  VALUES(41,'German Grand Prix','2016-07-06',6,8.2,77006,1);
INSERT INTO MoSpo_LapInfo  VALUES(42,'German Grand Prix','2016-07-06',6,8.2,76000,1);
INSERT INTO MoSpo_LapInfo  VALUES(43,'German Grand Prix','2016-07-06',6,8.2,76001,1);
INSERT INTO MoSpo_LapInfo  VALUES (44,'German Grand Prix','2016-07-06',6,7.8,74002,1);
INSERT INTO MoSpo_LapInfo  VALUES(45,'German Grand Prix','2016-07-06',6,8.2,75003,1);
INSERT INTO MoSpo_LapInfo  VALUES(46,'German Grand Prix','2016-07-06',6,8.2,74004,1);
INSERT INTO MoSpo_LapInfo  VALUES(47,'German Grand Prix','2016-07-06',6,8.2,74005,1);
INSERT INTO MoSpo_LapInfo  VALUES (48,'German Grand Prix','2016-07-06',6,7.8,76000,1);
INSERT INTO MoSpo_LapInfo  VALUES(49,'German Grand Prix','2016-07-06',6,8.2,73000,1);
INSERT INTO MoSpo_LapInfo  VALUES(50,'German Grand Prix','2016-07-06',6,8.2,72001,1);
INSERT INTO MoSpo_LapInfo  VALUES(51,'German Grand Prix','2016-07-06',6,8.2,72002,1);
INSERT INTO MoSpo_LapInfo  VALUES (52,'German Grand Prix','2016-07-06',6,7.8,77004,1);
INSERT INTO MoSpo_LapInfo  VALUES(53,'German Grand Prix','2016-07-06',6,8.2,71004,1);
INSERT INTO MoSpo_LapInfo  VALUES(54,'German Grand Prix','2016-07-06',6,8.2,70005,1);
INSERT INTO MoSpo_LapInfo  VALUES(55,'German Grand Prix','2016-07-06',6,8.2,70006,1);
INSERT INTO MoSpo_LapInfo  VALUES (56,'German Grand Prix','2016-07-06',6,7.8,78002,1);
INSERT INTO MoSpo_LapInfo  VALUES(57,'German Grand Prix','2016-07-06',6,8.2,69001,1);
INSERT INTO MoSpo_LapInfo  VALUES(58,'German Grand Prix','2016-07-06',6,8.2,68002,1);
INSERT INTO MoSpo_LapInfo  VALUES(59,'German Grand Prix','2016-07-06',6,8.2,68003,1);
INSERT INTO MoSpo_LapInfo  VALUES (60,'German Grand Prix','2016-07-06',6,2.5,NULL,0);
INSERT INTO MoSpo_Lap VALUES (1,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (2,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (3,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (4,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (5,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (6,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (7,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (8,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (9,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (10,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (11,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (12,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (13,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (14,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (15,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (16,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (17,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (18,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (19,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (20,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (21,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (22,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (23,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (24,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (25,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (26,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (27,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (28,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (29,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (30,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (31,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (32,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (33,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (34,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (35,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (36,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (37,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (38,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (39,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (40,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (41,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (42,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (43,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (44,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (45,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (46,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (47,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (48,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (49,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (50,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (51,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (52,'British Grand Prix','2017-06-30');
INSERT INTO MoSpo_Lap VALUES (1,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (2,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (3,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (4,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (5,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (6,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (7,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (8,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (9,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (10,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (11,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (12,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (13,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (14,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (15,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (16,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (17,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (18,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (19,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (20,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (21,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (22,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (23,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (24,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (25,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (26,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (27,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (28,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (29,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (30,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (31,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (32,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (33,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (34,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (35,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (36,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (37,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (38,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (39,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (40,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (41,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (42,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (43,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (44,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (45,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (46,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (47,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (48,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (49,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (50,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (51,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (52,'British Grand Prix','2018-07-06');
INSERT INTO MoSpo_Lap VALUES (1,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (2,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (3,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (4,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (5,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (6,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (7,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (8,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (9,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (10,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (11,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (12,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (13,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (14,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (15,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (16,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (17,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (18,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (19,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (20,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (21,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (22,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (23,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (24,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (25,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (26,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (27,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (28,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (29,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (30,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (31,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (32,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (33,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (34,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (35,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (36,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (37,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (38,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (39,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (40,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (41,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (42,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (43,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (44,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (45,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (46,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (47,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (48,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (49,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (50,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (51,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (52,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (53,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (54,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (55,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (56,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (57,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (58,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (59,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (60,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (61,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (62,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (63,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (64,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (65,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (66,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (67,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (68,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (69,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (70,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (71,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (72,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (73,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (74,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (75,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (76,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (77,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (78,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (79,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (80,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (81,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_Lap VALUES (82,'British GT Championship','2018-06-01');
INSERT INTO MoSpo_LapInfo  VALUES(1,'British GT Championship','2018-06-01',1,8.2,97001,1);
INSERT INTO MoSpo_LapInfo  VALUES(2,'British GT Championship','2018-06-01',1,8.2,96002,1);
INSERT INTO MoSpo_LapInfo  VALUES(3,'British GT Championship','2018-06-01',1,8.2,96003,1);
INSERT INTO MoSpo_LapInfo  VALUES (4,'British GT Championship','2018-06-01',1,7.8,61004,1);
INSERT INTO MoSpo_LapInfo  VALUES(5,'British GT Championship','2018-06-01',1,8.2,95005,1);
INSERT INTO MoSpo_LapInfo  VALUES(6,'British GT Championship','2018-06-01',1,8.2,94006,1);
INSERT INTO MoSpo_LapInfo  VALUES(7,'British GT Championship','2018-06-01',1,8.2,94000,1);
INSERT INTO MoSpo_LapInfo  VALUES (8,'British GT Championship','2018-06-01',1,7.8,62002,1);
INSERT INTO MoSpo_LapInfo  VALUES(9,'British GT Championship','2018-06-01',1,8.2,93002,1);
INSERT INTO MoSpo_LapInfo  VALUES(10,'British GT Championship','2018-06-01',1,8.2,92003,1);
INSERT INTO MoSpo_LapInfo  VALUES(11,'British GT Championship','2018-06-01',1,8.2,92004,1);
INSERT INTO MoSpo_LapInfo  VALUES (12,'British GT Championship','2018-06-01',1,7.8,64000,1);
INSERT INTO MoSpo_LapInfo  VALUES(13,'British GT Championship','2018-06-01',1,8.2,91006,1);
INSERT INTO MoSpo_LapInfo  VALUES(14,'British GT Championship','2018-06-01',1,8.2,90000,1);
INSERT INTO MoSpo_LapInfo  VALUES(15,'British GT Championship','2018-06-01',1,8.2,90001,1);
INSERT INTO MoSpo_LapInfo  VALUES (16,'British GT Championship','2018-06-01',1,7.8,65004,1);
INSERT INTO MoSpo_LapInfo  VALUES(17,'British GT Championship','2018-06-01',1,8.2,89003,1);
INSERT INTO MoSpo_LapInfo  VALUES(18,'British GT Championship','2018-06-01',1,8.2,88004,1);
INSERT INTO MoSpo_LapInfo  VALUES(19,'British GT Championship','2018-06-01',1,8.2,88005,1);
INSERT INTO MoSpo_LapInfo  VALUES (20,'British GT Championship','2018-06-01',1,7.8,66002,1);
INSERT INTO MoSpo_LapInfo  VALUES(21,'British GT Championship','2018-06-01',1,8.2,87000,1);
INSERT INTO MoSpo_LapInfo  VALUES (22,'British GT Championship','2018-06-01',1,2.5,NULL,0);
INSERT INTO MoSpo_Lap VALUES (1,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (2,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (3,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (4,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (5,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (6,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (7,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (8,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (9,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (10,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (11,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (12,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (13,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (14,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (15,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (16,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (17,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (18,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (19,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (20,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (21,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (22,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (23,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (24,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (25,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (26,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (27,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (28,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (29,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (30,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (31,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (32,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (33,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (34,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (35,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (36,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (37,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (38,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (39,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (40,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (41,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (42,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (43,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (44,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (45,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (46,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (47,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (48,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (49,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (50,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (51,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (52,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (53,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (54,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (55,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (56,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (57,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (58,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (59,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (60,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (61,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (62,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (63,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (64,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (65,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (66,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_Lap VALUES (67,'Italian Grand Prix','2018-09-07');
INSERT INTO MoSpo_LapInfo  VALUES(1,'Italian Grand Prix','2018-09-07',1,8.2,97001,1);
INSERT INTO MoSpo_LapInfo  VALUES(2,'Italian Grand Prix','2018-09-07',1,8.2,96002,1);
INSERT INTO MoSpo_LapInfo  VALUES(3,'Italian Grand Prix','2018-09-07',1,8.2,96003,1);
INSERT INTO MoSpo_LapInfo  VALUES (4,'Italian Grand Prix','2018-09-07',1,7.8,61004,1);
INSERT INTO MoSpo_LapInfo  VALUES(5,'Italian Grand Prix','2018-09-07',1,8.2,95005,1);
INSERT INTO MoSpo_LapInfo  VALUES(6,'Italian Grand Prix','2018-09-07',1,8.2,94006,1);
INSERT INTO MoSpo_LapInfo  VALUES(7,'Italian Grand Prix','2018-09-07',1,8.2,94000,1);
INSERT INTO MoSpo_LapInfo  VALUES (8,'Italian Grand Prix','2018-09-07',1,7.8,62002,1);
INSERT INTO MoSpo_LapInfo  VALUES(9,'Italian Grand Prix','2018-09-07',1,8.2,93002,1);
INSERT INTO MoSpo_LapInfo  VALUES(10,'Italian Grand Prix','2018-09-07',1,8.2,92003,1);
INSERT INTO MoSpo_LapInfo  VALUES(11,'Italian Grand Prix','2018-09-07',1,8.2,92004,1);
INSERT INTO MoSpo_LapInfo  VALUES (12,'Italian Grand Prix','2018-09-07',1,7.8,64000,1);
INSERT INTO MoSpo_LapInfo  VALUES(13,'Italian Grand Prix','2018-09-07',1,8.2,91006,1);
INSERT INTO MoSpo_LapInfo  VALUES(14,'Italian Grand Prix','2018-09-07',1,8.2,90000,1);
INSERT INTO MoSpo_LapInfo  VALUES(15,'Italian Grand Prix','2018-09-07',1,8.2,90001,1);
INSERT INTO MoSpo_LapInfo  VALUES (16,'Italian Grand Prix','2018-09-07',1,7.8,65004,1);
INSERT INTO MoSpo_LapInfo  VALUES(17,'Italian Grand Prix','2018-09-07',1,8.2,89003,1);
INSERT INTO MoSpo_LapInfo  VALUES(18,'Italian Grand Prix','2018-09-07',1,8.2,88004,1);
INSERT INTO MoSpo_LapInfo  VALUES(19,'Italian Grand Prix','2018-09-07',1,8.2,88005,1);
INSERT INTO MoSpo_LapInfo  VALUES (20,'Italian Grand Prix','2018-09-07',1,7.8,66002,1);
INSERT INTO MoSpo_LapInfo  VALUES(21,'Italian Grand Prix','2018-09-07',1,8.2,87000,1);
INSERT INTO MoSpo_LapInfo  VALUES(22,'Italian Grand Prix','2018-09-07',1,8.2,86001,1);
INSERT INTO MoSpo_LapInfo  VALUES(23,'Italian Grand Prix','2018-09-07',1,8.2,86002,1);
INSERT INTO MoSpo_LapInfo  VALUES (24,'Italian Grand Prix','2018-09-07',1,7.8,68000,1);
INSERT INTO MoSpo_LapInfo  VALUES(25,'Italian Grand Prix','2018-09-07',1,8.2,85004,1);
INSERT INTO MoSpo_LapInfo  VALUES(26,'Italian Grand Prix','2018-09-07',1,8.2,84005,1);
INSERT INTO MoSpo_LapInfo  VALUES(27,'Italian Grand Prix','2018-09-07',1,8.2,84006,1);
INSERT INTO MoSpo_LapInfo  VALUES (28,'Italian Grand Prix','2018-09-07',1,7.8,69004,1);
INSERT INTO MoSpo_LapInfo  VALUES(29,'Italian Grand Prix','2018-09-07',1,8.2,83001,1);
INSERT INTO MoSpo_LapInfo  VALUES(30,'Italian Grand Prix','2018-09-07',1,8.2,82002,1);
INSERT INTO MoSpo_LapInfo  VALUES(31,'Italian Grand Prix','2018-09-07',1,8.2,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (32,'Italian Grand Prix','2018-09-07',1,7.8,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES(33,'Italian Grand Prix','2018-09-07',1,8.2,81005,1);
INSERT INTO MoSpo_LapInfo  VALUES(34,'Italian Grand Prix','2018-09-07',1,8.2,80006,1);
INSERT INTO MoSpo_LapInfo  VALUES(35,'Italian Grand Prix','2018-09-07',1,8.2,80000,1);
INSERT INTO MoSpo_LapInfo  VALUES (36,'Italian Grand Prix','2018-09-07',1,7.8,72000,1);
INSERT INTO MoSpo_LapInfo  VALUES(37,'Italian Grand Prix','2018-09-07',1,8.2,79002,1);
INSERT INTO MoSpo_LapInfo  VALUES(38,'Italian Grand Prix','2018-09-07',1,8.2,78003,1);
INSERT INTO MoSpo_LapInfo  VALUES(39,'Italian Grand Prix','2018-09-07',1,8.2,78004,1);
INSERT INTO MoSpo_LapInfo  VALUES (40,'Italian Grand Prix','2018-09-07',1,7.8,73004,1);
INSERT INTO MoSpo_LapInfo  VALUES(41,'Italian Grand Prix','2018-09-07',1,8.2,77006,1);
INSERT INTO MoSpo_LapInfo  VALUES(42,'Italian Grand Prix','2018-09-07',1,8.2,76000,1);
INSERT INTO MoSpo_LapInfo  VALUES(43,'Italian Grand Prix','2018-09-07',1,8.2,76001,1);
INSERT INTO MoSpo_LapInfo  VALUES (44,'Italian Grand Prix','2018-09-07',1,7.8,74002,1);
INSERT INTO MoSpo_LapInfo  VALUES(45,'Italian Grand Prix','2018-09-07',1,8.2,75003,1);
INSERT INTO MoSpo_LapInfo  VALUES(46,'Italian Grand Prix','2018-09-07',1,8.2,74004,1);
INSERT INTO MoSpo_LapInfo  VALUES(47,'Italian Grand Prix','2018-09-07',1,8.2,74005,1);
INSERT INTO MoSpo_LapInfo  VALUES (48,'Italian Grand Prix','2018-09-07',1,7.8,76000,1);
INSERT INTO MoSpo_LapInfo  VALUES(49,'Italian Grand Prix','2018-09-07',1,8.2,73000,1);
INSERT INTO MoSpo_LapInfo  VALUES(50,'Italian Grand Prix','2018-09-07',1,8.2,72001,1);
INSERT INTO MoSpo_LapInfo  VALUES(51,'Italian Grand Prix','2018-09-07',1,8.2,72002,1);
INSERT INTO MoSpo_LapInfo  VALUES (52,'Italian Grand Prix','2018-09-07',1,7.8,77004,1);
INSERT INTO MoSpo_LapInfo  VALUES(53,'Italian Grand Prix','2018-09-07',1,8.2,71004,1);
INSERT INTO MoSpo_LapInfo  VALUES(54,'Italian Grand Prix','2018-09-07',1,8.2,70005,1);
INSERT INTO MoSpo_LapInfo  VALUES(55,'Italian Grand Prix','2018-09-07',1,8.2,70006,1);
INSERT INTO MoSpo_LapInfo  VALUES (56,'Italian Grand Prix','2018-09-07',1,2.5,NULL,0);
INSERT INTO MoSpo_LapInfo  VALUES(1,'Italian Grand Prix','2018-09-07',5,8.2,97001,1);
INSERT INTO MoSpo_LapInfo  VALUES(2,'Italian Grand Prix','2018-09-07',5,8.2,96002,1);
INSERT INTO MoSpo_LapInfo  VALUES(3,'Italian Grand Prix','2018-09-07',5,8.2,96003,1);
INSERT INTO MoSpo_LapInfo  VALUES (4,'Italian Grand Prix','2018-09-07',5,7.8,61004,1);
INSERT INTO MoSpo_LapInfo  VALUES(5,'Italian Grand Prix','2018-09-07',5,8.2,95005,1);
INSERT INTO MoSpo_LapInfo  VALUES(6,'Italian Grand Prix','2018-09-07',5,8.2,94006,1);
INSERT INTO MoSpo_LapInfo  VALUES(7,'Italian Grand Prix','2018-09-07',5,8.2,94000,1);
INSERT INTO MoSpo_LapInfo  VALUES (8,'Italian Grand Prix','2018-09-07',5,7.8,62002,1);
INSERT INTO MoSpo_LapInfo  VALUES(9,'Italian Grand Prix','2018-09-07',5,8.2,93002,1);
INSERT INTO MoSpo_LapInfo  VALUES(10,'Italian Grand Prix','2018-09-07',5,8.2,92003,1);
INSERT INTO MoSpo_LapInfo  VALUES(11,'Italian Grand Prix','2018-09-07',5,8.2,92004,1);
INSERT INTO MoSpo_LapInfo  VALUES (12,'Italian Grand Prix','2018-09-07',5,7.8,64000,1);
INSERT INTO MoSpo_LapInfo  VALUES(13,'Italian Grand Prix','2018-09-07',5,8.2,91006,1);
INSERT INTO MoSpo_LapInfo  VALUES(14,'Italian Grand Prix','2018-09-07',5,8.2,90000,1);
INSERT INTO MoSpo_LapInfo  VALUES(15,'Italian Grand Prix','2018-09-07',5,8.2,90001,1);
INSERT INTO MoSpo_LapInfo  VALUES (16,'Italian Grand Prix','2018-09-07',5,7.8,65004,1);
INSERT INTO MoSpo_LapInfo  VALUES(17,'Italian Grand Prix','2018-09-07',5,8.2,89003,1);
INSERT INTO MoSpo_LapInfo  VALUES(18,'Italian Grand Prix','2018-09-07',5,8.2,88004,1);
INSERT INTO MoSpo_LapInfo  VALUES(19,'Italian Grand Prix','2018-09-07',5,8.2,88005,1);
INSERT INTO MoSpo_LapInfo  VALUES (20,'Italian Grand Prix','2018-09-07',5,7.8,66002,1);
INSERT INTO MoSpo_LapInfo  VALUES(21,'Italian Grand Prix','2018-09-07',5,8.2,87000,1);
INSERT INTO MoSpo_LapInfo  VALUES(22,'Italian Grand Prix','2018-09-07',5,8.2,86001,1);
INSERT INTO MoSpo_LapInfo  VALUES(23,'Italian Grand Prix','2018-09-07',5,8.2,86002,1);
INSERT INTO MoSpo_LapInfo  VALUES (24,'Italian Grand Prix','2018-09-07',5,7.8,68000,1);
INSERT INTO MoSpo_LapInfo  VALUES(25,'Italian Grand Prix','2018-09-07',5,8.2,85004,1);
INSERT INTO MoSpo_LapInfo  VALUES(26,'Italian Grand Prix','2018-09-07',5,8.2,84005,1);
INSERT INTO MoSpo_LapInfo  VALUES(27,'Italian Grand Prix','2018-09-07',5,8.2,84006,1);
INSERT INTO MoSpo_LapInfo  VALUES (28,'Italian Grand Prix','2018-09-07',5,7.8,69004,1);
INSERT INTO MoSpo_LapInfo  VALUES(29,'Italian Grand Prix','2018-09-07',5,8.2,83001,1);
INSERT INTO MoSpo_LapInfo  VALUES(30,'Italian Grand Prix','2018-09-07',5,8.2,82002,1);
INSERT INTO MoSpo_LapInfo  VALUES(31,'Italian Grand Prix','2018-09-07',5,8.2,82003,1);
INSERT INTO MoSpo_LapInfo  VALUES (32,'Italian Grand Prix','2018-09-07',5,7.8,70002,1);
INSERT INTO MoSpo_LapInfo  VALUES(33,'Italian Grand Prix','2018-09-07',5,8.2,81005,1);
INSERT INTO MoSpo_LapInfo  VALUES(34,'Italian Grand Prix','2018-09-07',5,8.2,80006,1);
INSERT INTO MoSpo_LapInfo  VALUES(35,'Italian Grand Prix','2018-09-07',5,8.2,80000,1);
INSERT INTO MoSpo_LapInfo  VALUES (36,'Italian Grand Prix','2018-09-07',5,7.8,72000,1);
INSERT INTO MoSpo_LapInfo  VALUES(37,'Italian Grand Prix','2018-09-07',5,8.2,79002,1);
INSERT INTO MoSpo_LapInfo  VALUES(38,'Italian Grand Prix','2018-09-07',5,8.2,78003,1);
INSERT INTO MoSpo_LapInfo  VALUES(39,'Italian Grand Prix','2018-09-07',5,8.2,78004,1);
INSERT INTO MoSpo_LapInfo  VALUES (40,'Italian Grand Prix','2018-09-07',5,7.8,73004,1);
INSERT INTO MoSpo_LapInfo  VALUES(41,'Italian Grand Prix','2018-09-07',5,8.2,77006,1);
INSERT INTO MoSpo_LapInfo  VALUES(42,'Italian Grand Prix','2018-09-07',5,8.2,76000,1);
INSERT INTO MoSpo_LapInfo  VALUES(43,'Italian Grand Prix','2018-09-07',5,8.2,76001,1);
INSERT INTO MoSpo_LapInfo  VALUES (44,'Italian Grand Prix','2018-09-07',5,7.8,74002,1);
INSERT INTO MoSpo_LapInfo  VALUES(45,'Italian Grand Prix','2018-09-07',5,8.2,75003,1);
INSERT INTO MoSpo_LapInfo  VALUES(46,'Italian Grand Prix','2018-09-07',5,8.2,74004,1);
INSERT INTO MoSpo_LapInfo  VALUES(47,'Italian Grand Prix','2018-09-07',5,8.2,74005,1);
INSERT INTO MoSpo_LapInfo  VALUES (48,'Italian Grand Prix','2018-09-07',5,7.8,76000,1);
INSERT INTO MoSpo_LapInfo  VALUES(49,'Italian Grand Prix','2018-09-07',5,8.2,73000,1);
INSERT INTO MoSpo_LapInfo  VALUES(50,'Italian Grand Prix','2018-09-07',5,8.2,72001,1);
INSERT INTO MoSpo_LapInfo  VALUES(51,'Italian Grand Prix','2018-09-07',5,8.2,72002,1);
INSERT INTO MoSpo_LapInfo  VALUES (52,'Italian Grand Prix','2018-09-07',5,7.8,77004,1);
INSERT INTO MoSpo_LapInfo  VALUES(53,'Italian Grand Prix','2018-09-07',5,8.2,71004,1);
INSERT INTO MoSpo_LapInfo  VALUES(54,'Italian Grand Prix','2018-09-07',5,8.2,70005,1);
INSERT INTO MoSpo_LapInfo  VALUES(55,'Italian Grand Prix','2018-09-07',5,8.2,70006,1);
INSERT INTO MoSpo_LapInfo  VALUES (56,'Italian Grand Prix','2018-09-07',5,7.8,78002,1);
INSERT INTO MoSpo_LapInfo  VALUES(57,'Italian Grand Prix','2018-09-07',5,8.2,69001,1);
INSERT INTO MoSpo_LapInfo  VALUES(58,'Italian Grand Prix','2018-09-07',5,8.2,68002,1);
INSERT INTO MoSpo_LapInfo  VALUES(59,'Italian Grand Prix','2018-09-07',5,8.2,68003,1);
INSERT INTO MoSpo_LapInfo  VALUES (60,'Italian Grand Prix','2018-09-07',5,7.8,80000,1);
INSERT INTO MoSpo_LapInfo  VALUES(61,'Italian Grand Prix','2018-09-07',5,8.2,67005,1);
INSERT INTO MoSpo_LapInfo  VALUES(62,'Italian Grand Prix','2018-09-07',5,8.2,66006,1);
INSERT INTO MoSpo_LapInfo  VALUES(63,'Italian Grand Prix','2018-09-07',5,8.2,66000,1);
INSERT INTO MoSpo_LapInfo  VALUES (64,'Italian Grand Prix','2018-09-07',5,7.8,81004,1);
INSERT INTO MoSpo_LapInfo  VALUES(65,'Italian Grand Prix','2018-09-07',5,8.2,65002,1);
INSERT INTO MoSpo_LapInfo  VALUES (66,'Italian Grand Prix','2018-09-07',5,2.5,NULL,0);

INSERT INTO MoSpo_PitStop VALUES 
(18,'German Grand Prix','2018-07-20',5,'120010',NULL),
(26,'German Grand Prix','2018-07-20',44,'126567','tyre,nose'),
(42,'German Grand Prix','2018-07-20',44,'133345','front_wing'),
(50,'German Grand Prix','2018-07-20',44,'120122',NULL);
