CREATE TABLE CD_Performs(
artistId INT(10),
trackNo INT(10),
cdNo INT(10),
PRIMARY KEY (artistId, trackNo, cdNo),
FOREIGN KEY (artistId) REFERENCES CD_Artist(idNumber) ON DELETE RESTRICT ON UPDATE CASCADE,
FOREIGN KEY (trackNo,cdNo) REFERENCES CD_Track(trackNo,cdNo) ON DELETE CASCADE ON UPDATE CASCADE
);