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