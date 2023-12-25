SELECT therace.raceName, AVG(pitStops) AS avgStops FROM MoSpo_Race therace RIGHT JOIN 
(SELECT pitstop.pitstopRaceName AS raceName, pitstop.pitstopRaceDate, COUNT(pitstop.pitstopRaceName) AS pitStops
FROM MoSpo_PitStop pitstop WHERE (pitstop.pitstopRaceName, pitstop.pitstopRaceDate) IN
(SELECT race.raceName, race.raceDate FROM MoSpo_Race race)) AS pitstopTable
ON therace.raceName = pitstopTable.raceName