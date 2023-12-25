-- ---------------------------------------------------
-- DATABASES  Autumn 2018
-- This file contains the code you should run before
-- you attempt Questions 4ff on Sheet 7
-- (c) Bernhard Reus, University of Sussex
-- ------------------------------------------------------
-- 
-- The code in this file sets up the CD collection database
-- according to exercise sheets. This has the additional rating
-- in CD_CD already built-in. 
--
--
-- DISCLAIMER
-- Note that the copyright for artists' biographies
-- either lies with Wikipedia or certain authors as cited in
-- artistdirect.com.
-- The data is therefore just for educational purposes.
--
-- ---------------------------------------------------------


-- The following 6 lines delete the tables
-- should they already exist;
-- Has to be done in the right order
-- because of the foreign keys.

-- Note that if you have called your tables differently
-- then this script may fail if your differently named
-- tables have foreign keys referencing the deleted ones.
-- in this case you need to first delete those differently named tables.

DROP TABLE  IF EXISTS CD_Performs;
DROP TABLE  IF EXISTS CD_Genre;
DROP TABLE  IF EXISTS CD_Track;
DROP TABLE  IF EXISTS CD_CD;
DROP TABLE  IF EXISTS CD_Artist;
DROP TABLE  IF EXISTS CD_RecordLabel;


-- -------------------------
--
-- TABLES
--
-- --------------------


CREATE TABLE CD_RecordLabel ( 
labelName 	VARCHAR(30) PRIMARY KEY, 
webpage 	VARCHAR(40), 
house       CHAR(6), 
street      VARCHAR(50), 
postcode    CHAR(8), 
country		VARCHAR(30),
email 		VARCHAR(50),
town 		VARCHAR(25)
); 
  
 

CREATE TABLE CD_Artist (
idNumber 	INTEGER UNSIGNED AUTO_INCREMENT  PRIMARY KEY,
-- Note that INT is a synonym for INTEGER
artistName 	VARCHAR(50),
bio 		TEXT,     -- type was specified in question, 
					  -- equals VARCHAR(65535).
			  -- Note that TINYTEXT is too small, 
			  -- MEDIUMTEXT too large
email       VARCHAR(50),
webpage 	VARCHAR(50),
dateOfBirth	DATE
);
 
 
CREATE TABLE CD_CD (
catalogNo 		INTEGER UNSIGNED AUTO_INCREMENT PRIMARY KEY,
title           VARCHAR(50)	 NOT NULL,
publicationDate	DATE,
releasedBy      VARCHAR(30) 	 NOT NULL,
original        INTEGER UNSIGNED,
isFrontedBy     INTEGER UNSIGNED,
rating          ENUM ('favourite', 'excellent', 'good', 'so-so', 'poor', 'rubbish'),
-- table constraints 
CONSTRAINT fk_CD_Label_ FOREIGN KEY (releasedBy) REFERENCES CD_RecordLabel(labelName)
 ON UPDATE CASCADE,
CONSTRAINT fk_CD_Artist_  FOREIGN KEY (isFrontedBy) REFERENCES CD_Artist(idNumber)
 ON UPDATE CASCADE,
CONSTRAINT fk_CD_Original_  FOREIGN KEY (original) REFERENCES CD_CD(catalogNo) 
 ON DELETE SET NULL    ON UPDATE CASCADE
-- note that in mysql foreign key declaration must be done as table constraints
-- The extra underscores at the end are to avoid any clashes with other constraint names
);

  

 
CREATE TABLE CD_Genre  (
genre       VARCHAR(20),
catalogNo   INTEGER UNSIGNED,
-- table constraints
PRIMARY KEY (genre,catalogNo),
-- primary key with two or more attributes must be a table constraint
CONSTRAINT fk_Genre_CD FOREIGN KEY (catalogNo) REFERENCES CD_CD(catalogNo)
  ON DELETE CASCADE   ON UPDATE CASCADE
);



CREATE TABLE CD_Track (
trackNo 	DECIMAL(2,0) UNSIGNED,  --  type was specified in question
cdNo		INTEGER UNSIGNED,
trackTitle  VARCHAR(50) 	NOT NULL,
runtime 	TIME, -- don't use another type as this comes with useful functions and does exactly the right thing
-- table constraints
PRIMARY KEY (trackNo, cdNo),
CONSTRAINT fk_Track_CD FOREIGN KEY (cdNo) REFERENCES CD_CD(catalogNo) 
 ON DELETE CASCADE    ON UPDATE CASCADE
);
 



CREATE TABLE CD_Performs (
artistId  	INT UNSIGNED,
trackNo 	DECIMAL(2,0) UNSIGNED, 
cdNo        INTEGER UNSIGNED,
-- table constraints
PRIMARY KEY (artistId, trackNo, cdNo),
CONSTRAINT fk_Performs_Artist FOREIGN KEY (artistId) REFERENCES CD_Artist(idNumber),
CONSTRAINT fk_Performs_Track FOREIGN KEY (trackNo,cdNo) REFERENCES CD_Track(trackNo,cdNo)
 ON DELETE CASCADE    ON UPDATE CASCADE
);



-- ------------------------
--
-- DATA
--
-- ------------------------

-- The remainder of this file is to insert some data




INSERT INTO CD_RecordLabel VALUES ('Motown','www.motown.com','555', 'Madison Avenue','NY10022','US','randbfdn@aol.com','New York');
INSERT INTO CD_RecordLabel VALUES ('Grand Hustle Records','www.grandhustlegang.com',NULL, NULL,NULL,'US',NULL,'Atlanta');
INSERT INTO CD_RecordLabel VALUES ('Virgin','www.virginrecords.com','150', '5th Avenue' , 'NY10011','US',NULL, 'New York');
INSERT INTO CD_RecordLabel VALUES ('Polydor','www.polydor.co.uk','72', 'Black Lion Lane' , 'W6 9BE','UK','info@poldor.co.uk', 'London');
INSERT INTO CD_RecordLabel VALUES ('Apple','www.schomakers.com','27', 'Ovington Square' , 'SW3 1LJ ','UK',NULL, 'London');
INSERT INTO CD_RecordLabel VALUES ('RCA','www.rcalabelgroup.co.uk','9','Derry Street','SW6 1AH','UK' ,'rca@trinitystreetdirect.com', 'London');
INSERT INTO CD_RecordLabel VALUES ('Columbia','www.rcalabelgroup.co.uk','9','Derry Street','SW6 1AH','UK','rca@trinitystreetdirect.com', 'London');
INSERT INTO CD_RecordLabel VALUES ('Priority','www.priorityrecords.com','1750','Vine Street','CA90028','US' ,NULL, 'Los Angeles'),
				('Bronzerat','www.bronzerat.com',NULL,NULL,NULL,'UK','info@bronzerat.com','London');
INSERT INTO CD_RecordLabel VALUES ('Incipit','www.egeamusic.com',14,'Via Fratti','06125','Italy','info@egeamusic.com', 'Perugia');
INSERT INTO CD_RecordLabel VALUES ('Warner Bros.','www.warnerbrosrecords.com','3300','Warner Blvd','91505','US','fansupport@wbr.com','Burbank');
INSERT INTO CD_RecordLabel VALUES ('Atlantic','www.atlanticrecords.com',NUll,null,null,null,null,null);


 
INSERT INTO CD_Artist VALUES(11,'Three Dog Night','Three Dog Night scored a succession of 21 hit singles, including eleven Top Tens, and twelve consecutive gold albums from 1969 to 1975, thanks to the slick, sometimes soulful vocal harmonies of singers Danny Hutton, Chuck Negron, and Cory Wells and an excellent ear for quality material. While often criticized as commercial, the band was noted for its creative arrangements and interpretations,',NULL,'www.threedognight.com',NULL);

INSERT INTO CD_Artist VALUES(10,'Sugerloaf','Best known for their 1970 AM pop classic "Green-Eyed Lady," Sugarloaf was formed in 1969 in Denver out of the ashes of the Moonrakers, which had released an album in 1968. Singer/keyboardist Jerry Corbetta and guitarist Bob Webber founded the group, adding Moonraker mates Bob MacVittie on drums and Veeder Van Dorn on rhythm guitar, plus bassist Bob Raymond.',NULL,'www.sugarloafband.co.uk',NULL);

INSERT INTO CD_Artist VALUES(9,'Grand Funk Railroad','One of the 1970s'' most successful hard rock bands in spite of critical pans and somewhat reluctant radio airplay (at first), Grand Funk Railroad built a devoted fan base with constant touring, a loud, simple take on the blues-rock power trio sound, and strong working-class appeal. The band was formed by Flint, MI, guitarist/songwriter Mark Farner and drummer Don Brewer, both former members of a local band called Terry Knight & the Pack. They recruited former ? & the Mysterians bassist Mel Schacher in 1968, and Knight retired from performing to become their manager, naming the group after Michigan''s well-known Grand Trunk Railroad.

They performed for free at the 1969 Atlanta Pop Festival, and their energetic, if not technically proficient, show led Capitol Records to sign them at once. While radio shied away from Grand Funk Railroad, the group''s strong work ethic and commitment to touring produced a series of big-selling albums over the next few years; five of their eight releases from 1969 to 1972 went platinum, and the others all went gold.',NULL,'www.threedognight.com',NULL);

INSERT INTO CD_Artist VALUES(8,'Lynyrd Skynyrd','Lynyrd Skynyrd was the definitive Southern rock band, fusing the overdriven power of blues-rock with a rebellious Southern image and a hard rock swagger. Skynyrd never relied on the jazzy improvisations of the Allman Brothers. Instead, they were a hard-living, hard-driving rock & roll band -- they may have jammed endlessly on-stage, but their music remained firmly entrenched in blues, rock, and country. For many, Lynyrd Skynyrd''s redneck image tended to obscure the songwriting skills of their leader, Ronnie Van Zant. Throughout the band''s early records, Van Zant demonstrated a knack for lyrical detail and a down-to-earth honesty that had more in common with country than rock & roll. During the height of Skynyrd''s popularity in the mid-''70s, however, Van Zant''s talents were overshadowed by the group''s gritty, greasy blues-rock. Sadly, it wasn''t until he was killed in a tragic plane crash in 1977 along with two other bandmembers that many listeners began to realize his talents. Skynyrd split up after the plane crash, but they reunited a decade later, becoming a popular concert act during the early ''90s. ',NULL,'www.lynyrdskynyrd.com',NULL);

INSERT INTO CD_Artist VALUES(7,'Atlanta Rhythm Section','Often described as a more radio-friendly version of Lynyrd Skynyrd or the Allman Brothers, the Atlanta Rhythm Section was one of many Southern rock bands to hit the upper reaches of the charts during the late ''70s. Hailing from the small town of Doraville, Georgia, the beginning of the Atlanta Rhythm Section can be traced back to 1970. It was then that a local recording studio was opened, Studio One, and the remnants of two groups (the Candymen and the Classics Four), became the studio''s house band. One of the facility''s head figures, Buddy Buie, soon began assembling the session band -- singer Rodney Justo, guitarist Barry Bailey, bassist Paul Goddard, keyboardist Dean Daughtry, and drummer Robert Nix. After playing on several CD_Artists'' recordings, it was decided to take the band a step further and make the group of players a real band, leading to the formation of the Atlanta Rhythm Section. ',NULL,'www.atlantarhythmsection.com',NULL);

INSERT INTO CD_Artist VALUES(12,'Boston','The arena rock group behind one of the fastest-selling debut albums in history, Boston was essentially the vehicle of studio wizard Tom Scholz, born March 10, 1947, in Toledo, OH. A rock fan throughout his teen years, he began writing songs while earning a master''s degree at the Massachusetts Institute of Technology. After graduation, he began work for Polaroid, and set about constructing his own 12-track recording studio in the basement of his home, where demos were recorded that earned Scholz and vocalist Brad Delp a contract with Epic in 1975. Although some recording and overdubs were later done in Los Angeles, the 1976 release of Boston consisted largely of tapes recorded in Scholz''s basement. (By then, the lineup had coalesced around Scholz, Delp, guitarist Barry Goudreau, bassist Fran Sheehan, and drummer John "Sib" Hashian.) Boston spawned three hit singles ("More Than a Feeling," "Long Time," and "Peace of Mind"), and shot immediately to the top of the charts, remaining the best-selling pop debut effort in history before it was supplanted by Whitney Houston''s first album in 1986.

Despite the record''s overwhelming success, Scholz spent over two years working on the follow-up, 1978''s number one hit Don''t Look Back; a perfectionist, he only then released the album because of intense label pressure for product. Unsatisfied with the results, he swore to produce the next album at his own pace; as a result, the chart-topping Third Stage did not appear until 1986, at which time only Scholz and Delp remained from the original lineup.','webmaster@bandboston.com','www.bandboston.com',NULL);

INSERT INTO CD_Artist VALUES(18,'Little River Band','When Little River Band formed in 1975, Australia immediately took notice. The key bandmembers were already well known to Australians. Lead singer Glenn Shorrock had made his name in mid-''60s group the Twilights, a Beatles-sounding pop group that scored a national number one record with its version of the Velvelettes'' "Needle in a Haystack." When the group broke up in 1969, Shorrock became lead singer of Axiom, whose "A Little Ray of Sunshine" is still an Australian classic rock staple. LRB''s Beeb Birtles had been the bass player for a popular Twilights-era pop group called Zoot (Rick Springfield was a later member). When that group broke up, in search of musical credibility, Birtles auditioned as the bass player, but was instantly elevated to a front-line position alongside Graham Goble. Even LRB''s manager was well-known. Glenn Wheatley had been the bassist with another of Australia''s bands, and possibly its most legendary, the Masters Apprentices. Given all that background, when Shorrock and Birtles revealed they were forming a group with Goble, managed by Wheatley, it was major event in Australian music.

They had all had a shot at international stardom via England, without success. Little River Band were formed to conquer the world from Australia via America. With that in mind, they almost immediately went into the studio, even before the rest of the band had been consolidated. They were retaining Mississippi drummer Derek Pellicci and were on the lookout for a guitarist and a bass player. A very early version of the group recorded the Everly Brothers'' "When Will I Be Loved" as a single, a recording that was shelved when Linda Ronstadt also happened to choose that song as a single. The blueprint for Little River Band was country-rock as practiced by exponents like the Eagles.

Their self-titled first album was released in November 1975. The following May they released a second album, After Hours, and in September of that year set off on their first trip overseas to support Queen at Hyde Park and the Average White Band in the U.S. to promote the release of the first album. Its eight-and-a-half-minute epic "It''s a Long Way There" had been edited down for release as a single and was starting to make quite an impact. Graham Goble had written the song about the long trip taking his laundry back to his mother in Adelaide from Melbourne. To an America in shock after the Nixon presidency, the song took on a whole other dimension. LRB had made a big breakthrough. Their American record company decided that the second album, After Hours, was too dark, and put the band straight into the studio to record the next album, resolving to use some of the After Hours tracks and the best of what was being recorded for the band''s third Australian album. In both forms the result was called Diamantina Cocktail, produced by John Boylan (Linda Ronstadt). ',NULL,'www.littleriverband.com',NULL);

INSERT INTO CD_Artist VALUES(3,'Kansas','Fusing the complexity of British prog rock with an American heartland sound representative of their name, Kansas were among the most popular bands of the late ''70s; though typically dismissed by critics, many of the group''s hits remain staples of AOR radio play lists to this day. Formed in Topeka in 1970, the founding members of the group -- guitarist Kerry Livgren, bassist Dave Hope, and drummer Phil Ehart -- first played together while in high school; with the 1971 addition of classically trained violinist Robbie Steinhardt, they changed their name to White Clover, reverting back to the Kansas moniker for good upon the 1972 arrivals of vocalist/keyboardist Steve Walsh and guitarist Richard Williams. The group spent the early part of the decade touring relentlessly and struggling for recognition; initially, their mix of boogie and prog rock baffled club patrons, but in due time they established a strong enough following to win a record deal with the Kirshner label.

Kansas'' self-titled debut LP appeared in 1974; while only mildly successful, the group toured behind it tirelessly, and their fan base grew to the point that their third effort, 1975''s Masque, sold a quarter of a million copies. In 1976, Leftoverture truly catapulted Kansas to stardom. On the strength of the smash hit "Carry On Wayward Son," the album reached the Top Five and sold over three million copies. 1977''s Point of Know Return was even more successful, spawning the monster hit "Dust in the Wind." While the 1978 live LP Two for the Show struggled to break the Top 40, its studio follow-up, Monolith, the band''s first self-produced effort, reached the Top Ten. That same year, Walsh issued a solo record, Schemer-Dreamer.

In the wake of 1980''s Audio-Visions, Kansas began to splinter; both Hope and Livgren became born-again Christians, the latter issuing the solo venture Seeds of Change, and their newfound spirituality caused divisions within the band''s ranks. Walsh soon quit to form a new band, Streets; the remaining members forged on without him, tapping vocalist John Elefante as his replacement. The first Kansas LP without Walsh, 1982''s Vinyl Confessions, launched the hit "Play the Game Tonight," but after only one more album, 1983''s Drastic Measures, they disbanded. In 1986, however, Kansas re-formed around Ehart, Williams, and Walsh; adding the famed guitarist Steve Morse as well as bassist Billy Greer, the refurbished band debuted with the album Power, scoring a Top 20 hit with "All I Wanted." When the follow-up, 1988''s In the Spirit of Things, failed to hit, seven years passed before the release of their next effort, Freaks of Nature. Always Never the Same followed in 1998. Seeing the return of founder singer/songwriter Kerry Livgren, Somewhere to Elsewhere was released in 2000.  Jason Ankeny.',NULL,'www.kansasband.com',NULL);


INSERT INTO CD_Artist VALUES(52,'ELO','Electric Light Orchestra, commonly abbreviated ELO, were a symphonic rock group from Birmingham, England who released eleven studio albums between 1971 and 1986 and another album in 2001. ELO were formed to accommodate Roy Wood and Jeff Lynne''s desire to create modern pop songs with heavily classical overtones, but falling under a light rock category, however the band''s direction for most of their existence was set by Lynne who, after the band''s debut record, wrote and arranged all of the group''s original compositions and produced every album.',NULL,'www.elomusic.com',NULL);

INSERT INTO CD_Artist VALUES(13,'Styx','Styx is an American rock band. Their hit songs have included "Come Sail Away", "Babe", "Lady", "Mr. Roboto", and "Renegade." Styx is the first band to have four consecutive albums certified multi-platinum by the RIAA.','help@StyxWorld.com','www.styxworld.com',NULL);

INSERT INTO CD_Artist VALUES(14,'BTO','Bachman-Turner Overdrive (frequently known as BTO) is a Canadian rock group from Winnipeg, Manitoba, that enjoyed a string of hit albums and singles in the 1970s. The band has sold an estimated 20 million albums/CDs worldwide.',NULL,NULL,NULL);

INSERT INTO CD_Artist VALUES(15,'The Guess Who','The Guess Who is a Canadian rock band from Winnipeg, Manitoba, that was one of the first to establish a major successful following in their own country while still residing there. Produced by Jack Richardson, C.M., they were the first Canadian rock group to have a No.1 hit in the United States (see 1970 in music).',NULL,'www.theguesswhocafe.com',NULL);

INSERT INTO CD_Artist VALUES(16,'Rare Earth',NULL,NULL,'www.rareearth.com',NULL);

INSERT INTO CD_Artist VALUES(17,'Santana','Carlos Augusto Santana Alves (born July 20, 1947 in Jalisco, Mexico) is a Grammy Award-winning Mexican rock musician and guitarist. He became famous in the late 1960s and early 1970s with his band, Santana, which created a highly successful blend of rock, blues, salsa, and jazz fusion. The band''s sound featured his melodic, blues-based guitar lines set against Latin percussion such as timbales and congas. Santana continued to work in these forms over the following decades. He experienced a sudden resurgence of popularity and critical acclaim in the late 1990s. Rolling Stone also named Santana number 15 on their list of the 100 Greatest Guitarists of All Time in 2003.',NULL,'www.santana.com','1947-07-20');

INSERT INTO CD_Artist VALUES (6,'Beyoncé','Beyoncé Giselle Knowles (born September 4, 1981), commonly known as Beyoncé, is an American R&B singer-songwriter, record producer, and actress. Born and raised in Houston, Texas, she enrolled in various performing arts schools, and was first exposed to singing and dancing competitions as a child. Knowles rose to fame in the late 1990s as the lead singer of girl group Destiny''s Child, the best-selling girl group of all time.

After a series of commercial successes with the group, Knowles released her debut solo album, Dangerously in Love, in June 2003. The album became one of the most-successful albums of that year, spawning the number-one singles "Crazy in Love" and "Baby Boy". It earned Knowles five Grammy Awards in a single night in 2004, and its reception signaled her viability as a solo artist. The disbandment of Destiny''s Child in 2005 facilitated her continued success; she released her second album, B''Day, in 2006, which spawned the UK number-one singles "Déjà Vu" and "Beautiful Liar", and the worldwide hit "Irreplaceable". Knowles will release her third solo album titled I Am… Sasha Fierce on November 18, 2008. Knowles has sold over 63 million albums worldwide, including album sales in with Destiny''s Child.

The success of her solo albums has established Knowles as one of the most marketable artists in the industry. She has added acting and endorsement deals to her repertoire. In 2006, she starred in the comedy film The Pink Panther, and, in the same year, scored the main role in the film adaptation of the 1981 Broadway musical Dreamgirls, which earned her a Golden Globe nomination. Knowles launched in 2004 her family''s fashion line, House of Deréon, and among her many lucrative commercial deals are Pepsi, Tommy Hilfiger, and L''Oréal. Knowles has been with boyfriend Jay-Z since 2002, though they have been discreet about their relationship. After much speculation, they married on April 4, 2008.',
'B.Knowles@hotmail.com', 'www.beyonceonline.com','1981-09-04');

INSERT INTO CD_Artist VALUES (4,'The  Beatles', 'The Beatles were a pop and rock band from Liverpool, England formed in 1960. Primarily the band consisted of John Lennon (rhythm guitar, vocals), Paul McCartney (bass guitar, vocals), George Harrison (lead guitar, vocals) and Ringo Starr (drums, vocals). Throughout their career, The Beatles are recognised for leading the mid-1960s musical "British Invasion" into the United States. Although their initial musical style was rooted in 1950s rock and roll and homegrown skiffle, the group explored genres ranging from Tin Pan Alley to psychedelic rock. Their clothes, styles, and statements made them trend-setters, while their growing social awareness saw their influence extend into the social and cultural revolutions of the 1960s. After the band broke up in 1970, all four members embarked upon solo careers.

The Beatles are one of the most commercially successful and critically acclaimed bands in the history of popular music, selling over a billion records internationally.', NULL,'www.beatles.com','1960-01-01');

INSERT INTO CD_Artist VALUES(23,'Seasick Steve','Steven Gene Wold, commonly known as Seasick Steve, is an American bluesman, although he prefers to be called "a song and dance man". He plays guitars (mostly personalized), and sings, usually about his early life living rough and doing casual work.',NULL,'www.seasicksteve.com',NULL);

INSERT INTO CD_Artist VALUES (92,'Kali Uchis', 'Kali writes and produces most of her own music. She was introduced to music at a young age, when raised in the Alexandria school system, culminating in graduating from T. C. Williams High School, and began playing saxophone and piano as a teenager. She experimented with music production and video editing in high school and released her official debut mixtape, titled Drunken Babble on August 1, 2012. The mixtape was described as "genre-defying" and was noted for its influences from doo-wop, reggae, and early-2000s R&B. Uchis really liked jazz and played the saxophone. Some of her influences include Ella Fitzgerald and Billie Holiday.

Uchis began collaborating with rapper Snoop Dogg on the song "On Edge", from his 2014 mixtape That’’s My Work 3. That same year she debuted her first ever in-studio performance of "Never Be Yours" on the music podcast Kinda Neat. In February 2015, she released her first studio project, which is her first EP, titled Por Vida. The EP was also released for free on her website. Por Vida features production from Alex Epton, Diplo, Tyler, the Creator, Kaytranada, BadBadNotGood, and others.

In October 2015, Kali Uchis embarked on her first tour with Leon Bridges, touring through the United States and parts of Canada for a month.
Uchis was featured on the track "She’’s My Collar" from virtual band Gorillaz’’ fourth studio album Humanz, as well as on the bonus track "Ticker Tape". Her song "Sycamore Tree" was used in American Horror Story: Roanoke teasers in 2016.

On May 22, 2017, Uchis released "Tyrant" featuring Jorja Smith, the first single from her upcoming debut studio album. On June 20, she announced her first headlining tour, a North American tour to support the upcoming album. The tour will take place from August to October 2017, starting at the Outside Lands Music and Arts Festival in San Francisco, with a stop in Montreal during POP Montreal International Music Festival. On August 25, 2017, Uchis released "Nustro Planeta" featuring Reykon as the second single for her upcoming album.

On September 27, 2017, Lana Del Rey announced that Uchis would be joining her as an opening act on select North American arena dates of her upcoming world tour entitled the LA to the Moon Tour. Uchis will support Del Rey from January 15, 2018 to February 16, 2018.',null, 'www.kaliuchis.com','1994-07-14');


INSERT INTO CD_Artist VALUES (87,'Jorja Smith','Jorja Smith (born June 11, 1997) is an English singer from Walsall, West Midlands. She has independently released numerous singles and one extended play, Project 11 (2016), and is most known for her guest appearances on the songs "Jorja Interlude" and "Get It Together" from Canadian rapper Drake''s album More Life (2017).','@jorjasmith_','https://en-gb.facebook.com/jorjasmithmusic/','1997-06-11');

INSERT INTO CD_Artist VALUES(20,'Fleetwood Mac','Fleetwood Mac are a British-American rock band, formed in London in 1967. The band have sold more than 100 million records worldwide, making them one of the world''s best-selling bands. In 1998, selected members of Fleetwood Mac were inducted into the Rock and Roll Hall of Fame, and received the Brit Award for Outstanding Contribution to Music.

 Fleetwood Mac were founded by guitarist Peter Green, drummer Mick Fleetwood and guitarist Jeremy Spencer. They lacked a permanent bass guitarist for the first few months before Green convinced John McVie to join, establishing the first stable line-up in time to record their first album. Danny Kirwan joined as a third guitarist in 1969, and keyboardist Christine Perfect, who was used as a session musician starting with the second album, later married John McVie and joined the band in 1970. During this time period, the band was primarily a British blues outfit, scoring a UK number one with "Albatross"; and had lesser hits with the singles "Oh Well" and "Black Magic Woman". Personal problems led to original guitarists Green and Spencer leaving in short order, replaced by Bob Welch and Bob Weston.

In late 1974, while the band was scouting studios in Los Angeles, they were introduced to folk-rock duo Lindsey Buckingham and Stevie Nicks. The band sought to add Buckingham as their new lead guitarist, who agreed under the condition that Nicks, his singing partner and girlfriend at the time, also would join the band. The addition of Buckingham and Nicks caused the band to take on a more pop rock sound, with their 1975 album Fleetwood Mac becoming their best selling record to date, reaching No. 1 in the US. Rumours (1977), Fleetwood Mac''s second album after the incorporation of Buckingham and Nicks, produced four US Top 10 singles and remained at No. 1 on the American albums chart for 31 weeks, as well as reaching the top spot in various countries around the world. The album has sold over 40 million copies worldwide, making it the eighth-highest-selling album to date. During the recording of Rumours, the band went through personal turmoil, as both of the romantic partnerships in the band (John & Christine McVie and Buckingam & Nicks) separated, though the band kept making music together.

The lineup remained stable through three more studio albums, but by the late 1980s the band began to disintegrate. First to leave was Buckingham, followed by Nicks in 1991, to be replaced by a series of short-term guitarists and vocalists. In 1993, a one-off performance for the Presidential Inauguration of Bill Clinton featured the five key members back together for the first time in six years, and by 1997, a full reunion occurred. In 1998, Christine McVie retired from touring, and the band stayed together as a four-piece with John McVie, Mick Fleetwood, Lindsey Buckingham, and Stevie Nicks. In 2014, Christine McVie rejoined again full time. The latest studio album by the band was 2003''s Say You Will, though a side project known as Lindsey Buckingham/Christine McVie was released in 2017 containing contributions from the other band members.',null,'www.fleetwoodmac.com','1967-07-15');

INSERT INTO CD_Artist VALUES (82,'Marina and the Diamonds','Marina Lambrini Diamandis,known professionally as Marina and the Diamonds, is a Welsh singer-songwriter. Diamandis has described herself as an "indie artist with pop goals" and often analyses components of human behavior in her music. She is additionally known for her unconventional fashion styles.

Born in Brynmawr and raised in nearby Pandy, she moved to London as a teenager to become a professional singer, despite having little formal musical experience. In 2009, Diamandis came to prominence upon placing second in the BBC''s Sound of 2010. Her debut studio album, The Family Jewels (2010), incorporates indie pop and new wave musical styles. It entered the UK Albums Chart at number five and was certified gold by the British Phonographic Industry. The album''s second song, "Hollywood", peaked at number 12 on the UK Singles Chart.

Her follow-up record Electra Heart (2012) is a concept album about a character of the same name. It integrates elements of electropop, and its producers include StarGate, Dr. Luke, and Diplo. It became her first number-one project in the UK, where it was also certified gold, and its lead single "Primadonna" is her highest-charting track in the UK Singles Chart, reaching number 11. Diamandis describes Electra Heart as "tongue-in-cheek" and considers it to have been better received in the United States, while some British fans disliked the change in musical direction. The song "Electra Heart" portrays the death of the character. Diamandis''s synthpop-inspired third studio album Froot (2015) became her third top-ten album in the UK, and her first top-ten entry on the US Billboard 200, where it charted at number 8. Produced entirely by Diamandis and David Kosten, it was praised for its cohesive sound and introspective lyrical content.

Diamandis has grown a large fan base of millions of people worldwide since her 2010 debut, with her overall commercial success being described as comparable to that of Lorde or Lana Del Rey by Billboard.',null,'www.marinaandthediamonds.com', '1985-10-10');

INSERT INTO CD_Artist VALUES (88,'Miriam','Miriam was created 2003 in Turin.
The band members are: Mario Esposito (voce, chitarra), Gianmaria Vernetti (chitarra), Maurizio Lamorte (chitarra), Emanuele Bellotti (basso), Luca Di Natale (batteria), Maddalena Percivati (viola) e Simone Garino (sax).
The recorded the album SETE in 2011.',null,'https://it-it.facebook.com/IMiriam/','2003-03-01');


INSERT INTO CD_Artist VALUES (50,'Little Boots', 'Victoria Christina Hesketh (born 4 May 1984), also known by her stage name Little Boots, is an English electropop musician.  As a musician Little Boots sings and plays the keyboard, piano, stylophone and a Japanese electronic instrument, called Tenori-on. 

After a return to college to focus on her studies, Hesketh along with two of her fellow students formed the indie pop/electronic band Dead Disco. The band had limited releases of two their singles but due to increasingly different ideas about the band''s musical direction Hesketh left to pursue a solo career. 

Hesketh has cited Kylie Minogue, Britney Spears, Pink Floyd, The Human League and Madonna as influences.

Her new stage name was a nickname given to her from a friend who had seen the film Caligula (meaning ''Little Boot'' in Latin), although it was actually a reference to her small feet. Hesketh began writing her own songs and posting covers on the social networking sites such as Youtube and Myspace. After appearing on several shows including Later... with Jools Holland and Last Call with Carson Daly Hesketh entered production on her debut album Hands. With increasing media attention regarding her then yet to be released debut album Hesketh topped the BBC Sound of Music poll 2009 and received a BRIT Critics Choice nomination. With the release of her debut she has become linked to a wave of recent breakthrough female artists in their 20s including Lady Gaga, Ladyhawke, Florence and the Machine and La Roux. 

Her debut album, Hands, released on the 8 June 2009, peaked at #5 in the UK Albums Chart and at #20 on the Irish Albums Chart. The first single off the album "New In Town" became a Top 20 hit, with the next single "Remedy" produced by RedOne reaching the Top 10. She has also released the EP "Illuminations" in the US.', NULL, 'www.littlebootsmusic.co.uk','1984-05-04');


INSERT INTO CD_Artist VALUES (70,'b.o.b','B.o.B quickly rose to fame after his commercial debut single "Nothin'' on You", reached No. 1 in both the United States and the United Kingdom. He would later release his third single "Airplanes", which also topped several music charts. The album''s fifth single "Magic", became his third top ten hit on the Billboard Hot 100. B.o.B''s debut studio album The Adventures of Bobby Ray, which was preceded by two extended plays (EPs) and several mixtapes, was released on April 27, 2010. The album reaching No. 1 on the US Billboard charts and was eventually certified gold by the Recording Industry Association of America (RIAA). Later that year, B.o.B was named the ninth "Hottest MC in the Game of 2010" by MTV, on their annual list.
B.o.B released his second studio album Strange Clouds, on May 1, 2012. Strange Clouds spawned six singles, four of which all charted well internationally. "Strange Clouds", the album''s eponymous lead single, became his fourth top ten hit on the Billboard Hot 100. The singles "So Good", "Both of Us" and "Out of My Mind", followed behind, with the former two being certified Platinum by the RIAA. The album itself debuted at No. 5 on the Billboard 200. He is set to release a collaborative album with his Grand Hustle label-boss T.I. and an EP which will only include rock music, in the near future. B.o.B is currently working on the Grand Hustle compilation album as well as his third solo album Underground Luxury.',NULL,'www.bobatl.com','1988-11-15');

INSERT INTO CD_Artist VALUES(101,'Bruce Springsteen','Bruce Frederick Joseph Springsteen (born 
September 23, 1949) is an American songwriter, singer and guitarist. He has recorded 
and toured with the E Street Band. Springsteen is widely known for his brand of heartland 
rock infused with pop hooks, poetic lyrics, and Americana sentiments centered around his 
native New Jersey. His eloquence in expressing ordinary, everyday problems has earned 
him numerous awards, including eighteen Grammy Awards and an Academy Award, along 
with a notoriously dedicated and devoted global fan base. His most famous albums, Born to 
Run and Born in the U.S.A., epitomize his penchant for finding grandeur in the struggles 
of daily life. He has sold over 65 mil lion albums in the U.S, and 120 mil lion worldwide. 
Springsteen has long had the nickname The Boss, a term which he was initially reported 
to hate but now seems to have come to terms with, as he sometimes jokingly refers to himself as such on stage. The nickname originated when a young Springsteen, playing club gigs with a band in the 1960s, took on the task of collecting the band''s nightly pay and 
distributing it amongst his bandmates.',NULL,'www.brucespringsteen.net','1949-09-23'); 

INSERT INTO  CD_CD VALUES(20,'The Family Jewels','2010-02-15', 'Atlantic' ,NULL,82,'favourite');
INSERT INTO  CD_CD VALUES (7,'Sgt. Pepper''s Lonely Hearts Club Band','1967-06-01','Apple',NULL,4, 'excellent');
INSERT INTO  CD_CD VALUES (650,'I Am ... Sasha Fierce CD 1', '2008-11-10' ,'Columbia',NULL ,6,'good');
INSERT INTO  CD_CD VALUES (651,'I Am ... Sasha Fierce CD 2','2008-11-10','Columbia',NULL ,6,'good');
INSERT INTO  CD_CD VALUES (11,'Best of 70s Supergroups','1990-10-25','Priority',NULL,NULL,'favourite');
INSERT INTO  CD_CD VALUES (222,'Man of Another Time','2009-10-19','Bronzerat',NULL,23,'good');
INSERT INTO  CD_CD VALUES (25,'Underground Luxury','2013-12-17','Grand Hustle Records',NULL,70,'good');
INSERT INTO  CD_CD VALUES (12,'Questo è Pop','2018-03-17','Incipit',NULL,88,null);
INSERT INTO  CD_CD VALUES (13,'Isolation','2018-04-06','Virgin',NULL,92,null);
INSERT INTO  CD_CD VALUES (5,'Rumours','1977-02-04','Warner Bros.',null,20,'excellent');
INSERT INTO  CD_CD VALUES (70,'Magic','2007-10-01','Columbia', NULL, 101, 'excellent');


INSERT INTO  CD_Genre VALUES('Indie',20);
INSERT INTO  CD_Genre VALUES('Pop',20);
INSERT INTO  CD_Genre VALUES('Rock',5);
INSERT INTO  CD_Genre VALUES('Pop',7);
INSERT INTO  CD_Genre VALUES('Rock',7);
INSERT INTO  CD_Genre VALUES('R&B',650);
INSERT INTO  CD_Genre VALUES('Pop',650);
INSERT INTO  CD_Genre VALUES('Pop',11);
INSERT INTO  CD_Genre VALUES('Rock',11);
INSERT INTO  CD_Genre VALUES('Blues',222);
INSERT INTO  CD_Genre VALUES('R&B',13);
INSERT INTO  CD_Genre VALUES('Soul',13);
INSERT INTO  CD_Genre VALUES('Indie',12);
INSERT INTO  CD_Genre VALUES('Pop',12);


INSERT INTO CD_Track VALUES (1,7,'Sgt. Pepper''s Lonely Hearts Club Band','0:2:22');
INSERT INTO CD_Track VALUES (2,7,'With a Little Help from My Friends','0:2:44');
INSERT INTO CD_Track VALUES (3,7,'Lucy in the Sky with Diamonds','0:3:28');
INSERT INTO CD_Track VALUES (4,7,'Getting Better','0:2:47');
INSERT INTO CD_Track VALUES (5,7,'Fixing a Hole','0:2:36');
INSERT INTO CD_Track VALUES (6,7,'She''s Leaving Home','0:3:35');
INSERT INTO CD_Track VALUES (7,7,'Being for the Benefit of Mr. Kite!','0:2:37');
INSERT INTO CD_Track VALUES (8,7,'Within You Without You','0:5:05');
INSERT INTO CD_Track VALUES (9,7,'When I''m Sixty-Four','0:2:37');
INSERT INTO CD_Track VALUES (10,7,'Lovely Rita','0:2:42');
INSERT INTO CD_Track VALUES (11,7,'Good Morning Good Morning','0:2:41');
INSERT INTO CD_Track VALUES (12,7,'Sgt. Pepper''s Lonely Hearts Club Band (Reprise)','0:1:18');
INSERT INTO CD_Track VALUES (13,7,'A Day in the Life','0:5:33');


INSERT INTO CD_Performs VALUES (4,1,7), (4,2,7), (4,3,7), (4,4,7),(4,5,7),(4,6,7),(4,7,7),(4,8,7),
(4,9,7),(4,10,7),(4,11,7),(4,12,7),(4,13,7);

INSERT INTO CD_Track VALUES (1,650,'If I Were a Boy',NULL);
INSERT INTO CD_Track VALUES (2,650,'Halo', NULL);
INSERT INTO CD_Track VALUES (3,650,'Disappear', NULL);
INSERT INTO CD_Track VALUES (4,650,'Broken-Hearted Girl', NULL);
INSERT INTO CD_Track VALUES (5,650,'Ave Maria', NULL);
INSERT INTO CD_Track VALUES (6,650,'Satellites', NULL);
INSERT INTO CD_Track VALUES (1,651,'Single Ladies (Put a Ring on It)', NULL);
INSERT INTO CD_Track VALUES (2,651,'Radio', NULL);
INSERT INTO CD_Track VALUES (3,651,'Diva', NULL);
INSERT INTO CD_Track VALUES (4,651,'Sweet Dreams',NULL);
INSERT INTO CD_Track VALUES (5,651,'Video Phone', NULL);

INSERT INTO CD_Performs VALUES  (6,1,650),(6,2,650),(6,3,650),(6,4,650),(6,5,650),(6,6,650),
(6,1,651),(6,2,651),(6,3,651),(6,4,651),(6,5,651);


INSERT INTO CD_Track VALUES (1,11,'More than a Feeling','0:4:41');
INSERT INTO CD_Track VALUES (2,11,'Evil Woman','0:4:13');
INSERT INTO CD_Track VALUES (3,11,'Come Sail Away','0:4:58');
INSERT INTO CD_Track VALUES (4,11,'Taking Care of Business','0:4:52');
INSERT INTO CD_Track VALUES (5,11,'American Woman','0:05:08');
INSERT INTO CD_Track VALUES (6,11,'I Just Want to Celebrate','0:3:35');
INSERT INTO CD_Track VALUES (7,11,'Black Magic Woman','0:03:17');
INSERT INTO CD_Track VALUES (8,11,'Never Been to Spain','0:03:46');
INSERT INTO CD_Track VALUES (9,11,'Green Eyed Lady','0:03:38');
INSERT INTO CD_Track VALUES (10,11,'We''re an American Band','0:03:26');
INSERT INTO CD_Track VALUES (11,11,'Sweet Home Alabama','0:04:44');
INSERT INTO CD_Track VALUES (12,11,'So Into You','0:04:22');
INSERT INTO CD_Track VALUES (13,11,'Help Is On Its Way','0:04:01');
INSERT INTO CD_Track VALUES (14,11,'Dust in the Wind','0:03:23');
 
INSERT INTO CD_Performs VALUES  (12,1,11),(52,2,11),(13,3,11),(14,4,11),(15,5,11),(16,6,11),(17,7,11),(11,8,11),
(10,9,11),(9,10,11),(8,11,11),(7,12,11),( 18,13,11),(3 ,14,11);

INSERT INTO CD_Track VALUES (1,5,'Second Hand News','0:2:56');
INSERT INTO CD_Track VALUES (2,5,'Dreams','0:4:11');
INSERT INTO CD_Track VALUES (3,5,'Never Going Back Again','0:2:14');
INSERT INTO CD_Track VALUES (4,5,'Don''t Stop','0:3:13');
INSERT INTO CD_Track VALUES (5,5,'Go Your Own Way','0:3:38');
INSERT INTO CD_Track VALUES (6,5,'Songbird','0:3:20');
INSERT INTO CD_Track VALUES (7,5,'The Chain','0:4:30');
INSERT INTO CD_Track VALUES (8,5,'You Make Loving Fun','0:3:31');
INSERT INTO CD_Track VALUES (9,5,'I Don''t Want To Know','0:3:15');
INSERT INTO CD_Track VALUES (10,5,'Oh Daddy','0:3:56');
INSERT INTO CD_Track VALUES (11,5,'Gold Dust Woman','0:4:56');


INSERT INTO CD_Track VALUES (1,222,'Didley Boo','0:03:53');
INSERT INTO CD_Track VALUES (2,222,'Big Green And Yeller','0:04:15');
INSERT INTO CD_Track VALUES (3,222,'Happy To Have a Job','0:03:06');
INSERT INTO CD_Track VALUES (4,222,'The Banjo Song','0:03:30');
INSERT INTO CD_Track VALUES (5,222,'Man From Another Time','0:03:14');
INSERT INTO CD_Track VALUES (6,222,'That''s All','0:04:39');
INSERT INTO CD_Track VALUES (7,222,'Just Because I Can','0:03:40');
INSERT INTO CD_Track VALUES (8,222,'Never Go West','0:03:30');
INSERT INTO CD_Track VALUES (9,222,'Dark','0:03:55');
INSERT INTO CD_Track VALUES (10,222,'Wenatchee','0:03:54');
INSERT INTO CD_Track VALUES (11,222,'My Hone [Blue Eyes]','0:02:29');
INSERT INTO CD_Track VALUES (12,222,'Seasick Boogie','0:10:30');

INSERT INTO CD_Performs VALUES (23,1,222), (23,2,222), (23,3,222), (23,4,222),(23,5,222),(23,6,222),(23,7,222),(23,8,222),(23,9,222),(23,10,222),(23,11,222),(23,12,222);
INSERT INTO CD_Performs VALUES (20,1,5), (20,2,5), (20,3,5), (20,4,5),(20,5,5),(20,6,5),(20,7,5),(20,8,5),(20,9,5),(20,10,5),(20,11,5);

INSERT INTO CD_Track VALUES (1,12,'Plutone','0:2:59');
INSERT INTO CD_Track VALUES (6,13,'Tyrant','0:3:24');
INSERT INTO CD_Track VALUES (5,13,'Your Teeth in My Neck','0:3:06');
INSERT INTO CD_Track VALUES (4,13,'Flight 22','0:3:37');
INSERT INTO CD_Track VALUES (3,13,'Just a Stranger','0:2:58');
INSERT INTO CD_Track VALUES (2,13,'Miami','0:4:04');
INSERT INTO CD_Track VALUES (1,13,'Body Language (Intro)','0:2:16');
INSERT INTO CD_Track VALUES (7,13,'Dead to Me','0:3:20');
INSERT INTO CD_Track VALUES (9,13,'In My Dreams','0:3:21');
INSERT INTO CD_Track VALUES (8,13,'Nuestro Planeta','0:3:23');
INSERT INTO CD_Track VALUES (10,13,'Gotta Get Up (Interlude)','0:2:40');
INSERT INTO CD_Track VALUES (11,13,'Tomorrow','0:3:10');
INSERT INTO CD_Track VALUES (12,13,'Coming Home (Interlude)','0:2:40');
INSERT INTO CD_Track VALUES (13,13,'After the Storm','0:3:27');
INSERT INTO CD_Track VALUES (14,13,'Feels Like a Fool','0:3:05');
INSERT INTO CD_Track VALUES (15,13,'Killer','0:2:52');

INSERT INTO CD_Performs VALUES (88,1,12), (87,6,13), (92,5,13), (92,4,13), (92,3,13), (92,2,13), (92,1,13),
(92,6,13),(92,7,13),(92,8,13),(92,9,13),(92,10,13),(92,11,13),(92,12,13),(92,13,13),(92,14,13),(92,15,13);

INSERT INTO CD_Track VALUES (10,70,'Long Walk Home','0:4:35');
INSERT INTO CD_Performs VALUES (101,10,70);

INSERT INTO CD_CD (catalogNo,title,releasedBy,original,isFrontedBy,publicationDate,rating) 
VALUES (999,'Sgt. Pepper Remix','Apple',7,4,'2001-09-01','so-so'); 

INSERT INTO CD_Genre VALUES ('Pop',999);
