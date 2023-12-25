CREATE PROCEDURE totalRaceTime(varRaceNo TINYINT(3), varRaceName VARCHAR(30), varRaceDate DATE)
BEGIN
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
IF lapno < raceLaps THEN CALL TimeForAllLaps(); END IF;
IF retired = 0 THEN SELECT NULL AS totalRaceTime;
ELSE SELECT SUM(lapinfo.lapInfoTime) AS totalRaceTime FROM MoSpo_LapInfo lapinfo WHERE lapinfo.lapInfoRaceName = varRaceName AND lapinfo.lapInfoRaceDate = varRaceDate AND lapinfo.lapInfoRaceNumber = varRaceNo;
END IF;
END
$$