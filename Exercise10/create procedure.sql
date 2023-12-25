CREATE PROCEDURE setAllFavourite(aname VARCHAR(50))
BEGIN
DECLARE counter INT;
SELECT COUNT(*) INTO counter
FROM CD_CD JOIN CD_Artist ON isFrontedBy = idNumber
WHERE artistName SOUNDS LIKE aname;
IF counter > 1
	THEN
		UPDATE CD_CD
		SET rating = 'favourite'
		WHERE isFrontedBy IN
				(SELECT idNumber
				 FROM CD_Artist
				 WHERE artistName SOUNDS LIKE aname
				);
END IF;
END
$$