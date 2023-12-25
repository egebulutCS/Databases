CREATE PROCEDURE numberFavourites(agenre VARCHAR(20))
BEGIN
SELECT cd.catalogNo FROM CD_CD cd WHERE cd.catalogNo IN
(SELECT genre.catalogNo FROM CD_Genre genre WHERE genre.genre = agenre)
AND cd.rating = 'favourite';
END
$$