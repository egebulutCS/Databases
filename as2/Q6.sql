SELECT MoSpo_Driver.driverId,
CONCAT(SUBSTRING(MoSpo_Driver.driverFirstname, 1, 1),
" ",
MoSpo_Driver.driverLastname)
AS driverName, MoSpo_Driver.driverDOB
FROM MoSpo_Driver
WHERE SUBSTRING(MoSpo_Driver.driverFirstname, 1, 1) =
SUBSTRING(MoSpo_Driver.driverLastname, 1, 1); 