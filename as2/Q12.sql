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