SELECT team.teamName,
COUNT(driver.driverId) AS numberOfDriver
FROM MoSpo_Driver driver
JOIN MoSpo_RacingTeam team
ON driver.driverTeam = team.teamName
GROUP BY team.teamName
HAVING numberOfDriver>1;