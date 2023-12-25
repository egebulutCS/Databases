CREATE TRIGGER check_track_runtime
BEFORE INSERT ON CD_Track
FOR EACH ROW
BEGIN
DECLARE X INT;
SELECT IFNULL(SUM(TIME_TO_SEC(track.runtime)),0) AS totalRuntime INTO X
FROM CD_Track track RIGHT JOIN CD_CD cd
ON track.cdNo = cd.catalogNo
GROUP BY cd.catalogNo HAVING cd.catalogNo = NEW.cdNo;
IF (X + TIME_TO_SEC(NEW.runtime)) > 7200
	THEN CALL total_runtime_exceeded();
END IF;
END
$$