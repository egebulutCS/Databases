SELECT cd.catalogNo, cd.title, COUNT(track.cdNo) AS total
FROM CD_Track track
LEFT OUTER JOIN CD_CD cd
ON track.cdNo = cd.catalogNo
GROUP BY cd.catalogNo
HAVING COUNT(track.cdNo) < (
SELECT COUNT(track.trackNo) AS genretotal
FROM CD_Track track
LEFT OUTER JOIN CD_CD cd
ON track.cdNo = cd.catalogNo
WHERE cd.catalogNo = (
SELECT CD_Genre.catalogNo AS cdno
FROM CD_Genre
WHERE CD_Genre.genre = "Soul"))

