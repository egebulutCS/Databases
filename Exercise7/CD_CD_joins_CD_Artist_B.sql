SELECT CD_CD.title, CD_Artist.artistName FROM CD_CD INNER JOIN CD_Artist ON CD_CD.isFrontedBy = CD_Artist.idNumber WHERE CD_Artist.artistName LIKE BINARY "B%" ORDER BY CD_Artist.artistName ASC;