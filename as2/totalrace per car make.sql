SELECT car.carMake, totalRace FROM MoSpo_Car car LEFT JOIN 
(SELECT race.raceEntryCarId, COUNT(race.raceEntryCarId) AS totalRace FROM MoSpo_RaceEntry race GROUP BY race.raceEntryCarId) AS raceTable
ON car.carId = raceTable.raceEntryCarId HAVING totalRace IS NOT NULL ORDER BY totalRace DESC