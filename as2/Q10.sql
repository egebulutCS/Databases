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