

SELECT car.carMake, SUM(therace.totalRetirement) AS retirement FROM MoSpo_Car car
LEFT JOIN
(SELECT race.raceEntryCarId AS carid, COUNT(race.raceEntryCarId) AS totalRetirement FROM MoSpo_RaceEntry race
RIGHT JOIN
(SELECT lapinfo.lapInfoRaceNumber, lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate FROM MoSpo_LapInfo lapinfo WHERE lapinfo.lapInfoCompleted = 0) AS lapinfo
ON (race.raceEntryNumber, race.raceEntryRaceName, race.raceEntryRaceDate) = (lapinfo.lapInfoRaceNumber, lapinfo.lapInfoRaceName, lapinfo.lapInfoRaceDate) GROUP BY race.raceEntryCarId) AS therace
ON car.carId = therace.carid GROUP BY car.carMake ORDER BY retirement DESC;