CREATE TABLE CD_CD (
catalogNo		INT(10)	PRIMARY KEY,
title			VARCHAR(15) NOT NULL,
publicationDate	DATE,
releasedBy		VARCHAR(30) NOT NULL,
original		INT(10),
isFrontedBy		INT(10),
FOREIGN KEY (releasedBy)  REFERENCES CD_RecordLabel(labelName),
FOREIGN KEY (original)	  REFERENCES CD_CD(catalogNo),
FOREIGN KEY	(isFrontedBy) REFERENCES CD_Artist(idNumber)
);