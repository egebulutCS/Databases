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