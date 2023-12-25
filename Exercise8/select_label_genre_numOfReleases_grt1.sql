SELECT CD_CD.releasedBy AS label, CD_Genre.genre, COUNT(releasedBy) AS numOfReleases FROM CD_CD JOIN CD_Genre ON CD_CD.catalogNo = CD_Genre.catalogNo GROUP BY CD_Genre.genre HAVING numOfReleases > 1 ORDER BY numOfReleases DESC, label ASC, CD_Genre.genre ASC;