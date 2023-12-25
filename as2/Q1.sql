CREATE TABLE MoSpo_HallOfFame (
hoFdriverId INT UNSIGNED,
hoFYear INT(4) CHECK((hoFYear BETWEEN 1901 AND 2155) OR (hoFYear = 0000)),
hoFSeries ENUM('BritishGT', 'Formula1', 'FormulaE', 'SuperGt') NOT NULL,
hoFWins INT(2) UNSIGNED DEFAULT 0 CHECK(hoFWins<100),
hoFImage VARCHAR(200),
hoFBestRaceName VARCHAR(30),
hoFBestRaceDate DATE,
PRIMARY KEY (hoFDriverId, hoFYear),
FOREIGN KEY (hoFDriverId) REFERENCES MoSpo_Driver(driverId) ON DELETE CASCADE,
FOREIGN KEY (hoFBestRaceName, hoFBestRaceDate) REFERENCES MoSpo_Race(raceName, raceDate) ON DELETE SET NULL
);