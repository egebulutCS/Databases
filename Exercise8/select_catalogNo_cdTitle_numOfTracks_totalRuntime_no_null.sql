SELECT cd.catalogNo, cd.title AS cdTitle, COUNT(track.trackNo) AS numOfTracks, SEC_TO_TIME(SUM(TIME_TO_SEC(track.runtime))) AS totalRuntime FROM CD_Track track RIGHT JOIN CD_CD cd ON track.cdNo = cd.catalogNo GROUP BY cd.catalogNo HAVING totalRuntime IS NOT NULL;