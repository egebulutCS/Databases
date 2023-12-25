SELECT MoSpo_LapInfo.lapInfoRaceName AS raceName,
MoSpo_LapInfo.lapInfoRaceDate AS raceDate,
MIN(MoSpo_LapInfo.lapInfoTime) AS lapTime
FROM MoSpo_LapInfo
GROUP BY MoSpo_LapInfo.lapInfoRaceName;