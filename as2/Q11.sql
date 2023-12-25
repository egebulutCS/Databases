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