-- Answer to the 2nd Database Assignment 2018/19
--
-- CANDIDATE NUMBER 181509
-- Please insert your candidate number in the line above.
-- Do NOT remove ANY lines of this template.


-- In each section below put your answer in a new line 
-- BELOW the corresponding comment.
-- Use ONE SQL statement ONLY per question.
-- If you don’t answer a question just leave 
-- the corresponding space blank. 
-- Anything that does not run in SQL you MUST put in comments.
-- Your code should never throw a syntax error.
-- Questions with syntax errors will receive zero marks.

-- DO NOT REMOVE ANY LINE FROM THIS FILE.

-- START OF ASSIGNMENT CODE


-- @@01

CREATE TABLE MoSpo_HallOfFame (
hoFdriverId INT UNSIGNED,
hoFYear INT(4) CHECK((hoFYear BETWEEN 1901 AND 2155) OR (hoFYear = 0000)),
hoFSeries ENUM('BritishGT', 'Formula1', 'FormulaE', 'SuperGt') NOT NULL,
hoFWins INT(2) UNSIGNED DEFAULT 0 CHECK(hoFWins<100),
hoFImage VARCHAR(200),
hoFBestRaceName VARCHAR(30),
hoFBestRaceDate DATE,
PRIMARY KEY (hoFDriverId, hoFYear),
FOREIGN KEY (hoFDriverId) REFERENCES MoSpo_Driver(driverId) ON DELETE CASCADE,
FOREIGN KEY (hoFBestRaceName, hoFBestRaceDate) REFERENCES MoSpo_Race(raceName, raceDate) ON DELETE SET NULL
);
 
-- @@02

ALTER TABLE MoSpo_HallOfFame ADD driverWeight FLOAT(3,1);

-- @@03

UPDATE MoSpo_RacingTeam
SET MoSpo_RacingTeam.teamPostcode = "HP135PN"
WHERE MoSpo_RacingTeam.teamName = "Beechdean Motorsport";

-- @@04

DELETE FROM MoSpo_Driver
WHERE MoSpo_Driver.driverLastname = "Senna"
AND MoSpo_Driver.driverFirstname = "Ayrton";

-- @@05

SELECT COUNT(MoSpo_RacingTeam.teamName)
AS numberTeams
FROM MoSpo_RacingTeam;

-- @@06

SELECT MoSpo_Driver.driverId,
CONCAT(SUBSTRING(MoSpo_Driver.driverFirstname, 1, 1),
" ",
MoSpo_Driver.driverLastname)
AS driverName, MoSpo_Driver.driverDOB
FROM MoSpo_Driver
WHERE SUBSTRING(MoSpo_Driver.driverFirstname, 1, 1) =
SUBSTRING(MoSpo_Driver.driverLastname, 1, 1); 

-- @@07

SELECT team.teamName,
COUNT(driver.driverId) AS numberOfDriver
FROM MoSpo_Driver driver
JOIN MoSpo_RacingTeam team
ON driver.driverTeam = team.teamName
GROUP BY team.teamName
HAVING numberOfDriver>1;

-- @@08

SELECT MoSpo_LapInfo.lapInfoRaceName AS raceName,
MoSpo_LapInfo.lapInfoRaceDate AS raceDate,
MIN(MoSpo_LapInfo.lapInfoTime) AS lapTime
FROM MoSpo_LapInfo
GROUP BY MoSpo_LapInfo.lapInfoRaceName;

-- @@09

SELECT race.raceName,
IFNULL(SUM(totalPitstop),0)/COUNT(race.raceName) AS avgStops
FROM MoSpo_Race race LEFT JOIN
(SELECT pitstop.pitstopRaceName,
pitstop.pitstopRaceDate,
COUNT(pitstop.pitstopRaceNumber) AS totalPitstop
FROM MoSpo_PitStop pitstop
GROUP BY pitstop.pitstopRaceName,
pitstop.pitstopRaceDate) AS innerpitstop
ON (race.raceName, race.raceDate) =
(innerpitstop.pitstopRaceName, innerpitstop.pitstopRaceDate)
GROUP BY race.raceName

-- @@10

SELECT car.carMake
FROM MoSpo_Car car
WHERE car.carId IN (
SELECT raceEntry.raceEntryCarId AS carId
FROM MoSpo_RaceEntry raceEntry
WHERE (raceEntry.raceEntryNumber,
raceEntry.raceEntryRaceName) IN
(SELECT lapInfo.lapInfoRaceNumber AS raceNumber,
lapInfo.lapInfoRaceName AS raceName
FROM MoSpo_LapInfo lapInfo
WHERE lapInfo.lapInfoCompleted = 0)
AND YEAR(raceEntry.raceEntryRaceDate) = 2018);

-- @@11

SELECT race.raceName,
race.raceDate,
IFNULL(mostPitstops,0) AS mostPitstops
FROM MoSpo_Race race LEFT JOIN 
(SELECT therace.raceEntryRaceName,
therace.raceEntryRaceDate,
MAX(mostPitstops) AS mostPitstops
FROM MoSpo_RaceEntry therace RIGHT JOIN
(SELECT raceEntry.raceEntryRaceName,
raceEntry.raceEntryRaceDate,
COUNT(raceEntry.raceEntryCarId) AS mostPitstops
FROM MoSpo_RaceEntry raceEntry RIGHT JOIN
(SELECT pitstop.pitstopRaceNumber,
pitstop.pitstopRaceName,
pitstop.pitstopRaceDate
FROM MoSpo_PitStop pitstop) AS pitstops
ON (raceEntry.raceEntryNumber,
raceEntry.raceEntryRaceName,
raceEntry.raceEntryRaceDate) =
(pitstops.pitstopRaceNumber,
pitstops.pitstopRaceName,
pitstops.pitstopRaceDate)
GROUP BY raceEntry.raceEntryCarId) AS counts
ON (counts.raceEntryRaceName,
counts.raceEntryRaceDate) =
(therace.raceEntryRaceName,
therace.raceEntryRaceDate)) AS finalrace
ON (finalrace.raceEntryRaceName,
finalrace.raceEntryRaceDate) =
(race.raceName, race.raceDate)

-- @@12

SELECT driver.driverId,
driver.driverLastname
FROM MoSpo_Driver driver
WHERE driver.driverId IN (
SELECT DISTINCT raceEntry.raceEntryDriverId
FROM MoSpo_RaceEntry raceEntry
WHERE (raceEntry.raceEntryRaceName,
raceEntry.raceEntryRaceDate,
raceEntry.raceEntryNumber) NOT IN
(SELECT lapInfo.lapInfoRaceName,
lapInfo.lapInfoRaceDate,
lapInfo.lapInfoRaceNumber
FROM MoSpo_LapInfo lapInfo
WHERE lapInfo.lapInfoCompleted = 0));

-- @@13

SELECT car.carMake, SUM(theraceEntry.theretirement)/SUM(theraceEntry.raceCount) AS retirementRate FROM MoSpo_Car car RIGHT JOIN
(SELECT raceEntry.raceEntryCarId, SUM(thelapinfo.retirement) AS theretirement, COUNT(raceEntry.raceEntryCarId) AS raceCount FROM MoSpo_RaceEntry raceEntry LEFT JOIN
(SELECT lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate, lapinfo.lapInfoRaceNumber, COUNT(lapinfo.lapInfoCompleted) AS retirement FROM MoSpo_LapInfo lapinfo WHERE lapinfo.lapInfoCompleted = 0 GROUP BY lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate, lapinfo.lapInfoRaceNumber) AS thelapinfo
ON (thelapinfo.lapInfoRaceNumber, thelapinfo.lapInfoRaceName, thelapinfo.lapInfoRaceDate) = (raceEntry.raceEntryNumber, raceEntry.raceEntryRaceName, raceEntry.raceEntryRaceDate) GROUP BY raceEntry.raceEntryCarId,YEAR(raceEntry.raceEntryRaceDate)) AS theraceEntry
ON theraceEntry.raceEntryCarId = car.carId GROUP BY car.carMake HAVING retirementRate > (SELECT AVG(finalretirement.AverageRetirementRate) AS AverageRetirementRate FROM
(SELECT SUM(theraceEntry.theretirement)/SUM(theraceEntry.raceCount) AS AverageRetirementRate FROM MoSpo_Car car RIGHT JOIN
(SELECT raceEntry.raceEntryCarId, SUM(thelapinfo.retirement) AS theretirement, COUNT(raceEntry.raceEntryCarId) AS raceCount FROM MoSpo_RaceEntry raceEntry LEFT JOIN
(SELECT lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate, lapinfo.lapInfoRaceNumber, COUNT(lapinfo.lapInfoCompleted) AS retirement FROM MoSpo_LapInfo lapinfo WHERE lapinfo.lapInfoCompleted = 0 GROUP BY lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate, lapinfo.lapInfoRaceNumber) AS thelapinfo
ON (thelapinfo.lapInfoRaceNumber, thelapinfo.lapInfoRaceName, thelapinfo.lapInfoRaceDate) = (raceEntry.raceEntryNumber, raceEntry.raceEntryRaceName, raceEntry.raceEntryRaceDate) GROUP BY raceEntry.raceEntryCarId,YEAR(raceEntry.raceEntryRaceDate)) AS theraceEntry
ON theraceEntry.raceEntryCarId = car.carId) AS finalretirement)

-- Do not write any DELIMITER command in the submission.
-- For Q14 OMIT the termination symbol at the end of your 
-- function declaration


-- @@14

CREATE FUNCTION totalRaceTime(varRaceNo TINYINT(3), varRaceName VARCHAR(30), varRaceDate DATE)
RETURNS INT
BEGIN
DECLARE totalRaceTime INT;
DECLARE retired INT;
DECLARE lapno INT;
DECLARE raceLaps INT;

SELECT COUNT(lapinfo.lapInfoLapNo) INTO lapno FROM MoSpo_LapInfo lapinfo WHERE lapinfo.lapInfoRaceName = varRaceName AND lapinfo.lapInfoRaceDate = varRaceDate AND lapinfo.lapInfoRaceNumber = varRaceNo;

SELECT race.raceLaps INTO raceLaps FROM MoSpo_Race race WHERE race.raceName = varRaceName AND race.raceDate = varRaceDate;

SELECT lapinfo.lapInfoCompleted INTO retired FROM MoSpo_LapInfo lapinfo RIGHT JOIN 
(SELECT race.raceLaps, race.raceName, race.raceDate FROM MoSpo_Race race WHERE race.raceName = varRaceName AND race.raceDate = varRaceDate) AS therace
ON (lapinfo.lapInfoLapNo, lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate) = (therace.raceLaps, therace.raceName, therace.raceDate) WHERE lapinfo.lapInfoRaceNumber = varRaceNo;

IF (varRaceName, varRaceDate) NOT IN (SELECT race.raceName, race.raceDate FROM MoSpo_Race race) THEN CALL Race(); END IF;
IF (varRaceNo, varRaceName, varRaceDate) NOT IN (SELECT raceEntry.raceEntryNumber, raceEntry.raceEntryRaceName, raceEntry.raceEntryRaceDate FROM MoSpo_RaceEntry raceEntry) THEN CALL RaceEntry(); END IF;
IF lapno <> raceLaps THEN CALL TimeForAllLaps(); END IF;
IF retired = 0 THEN SET totalRaceTime = NULL;
ELSE SET totalRaceTime = (SELECT SUM(lapinfo.lapInfoTime) AS totalRaceTime FROM MoSpo_LapInfo lapinfo WHERE lapinfo.lapInfoRaceName = varRaceName AND lapinfo.lapInfoRaceDate = varRaceDate AND lapinfo.lapInfoRaceNumber = varRaceNo);
END IF;
RETURN totalRaceTime;
END
 

-- END OF ASSIGNMENT CODE
