CREATE DATABASE IF NOT EXISTS MuseMatchLiveDB;


-- Via the Docker Compose file, a special user called webapp will
-- be created in MySQL. We are going to grant that user
-- all privilages to the new database we just created.
-- TODO: If you changed the name of the database above, you need
-- to change it here too.
grant all privileges on MuseMatchLiveDB.* to 'webapp'@'%';
flush privileges;

-- show databases;

USE MuseMatchLiveDB;

CREATE TABLE IF NOT EXISTS TraditionalUsers
(
    user_id             int             primary key AUTO_INCREMENT,
    first_name          varchar(50)     NOT NULL,
    last_name           varchar(50)     NOT NULL,
    email               varchar(100)    NOT NULL UNIQUE,
    city                varchar(100)    NOT NULL,
    state               varchar(100)    NOT NULL,
    zip                 varchar(100)    NOT NULL
);

CREATE TABLE IF NOT EXISTS Genres
(
    genre_id            int             primary key AUTO_INCREMENT,
    genre_name          varchar(50)     NOT NULL UNIQUE
);

CREATE TABLE IF NOT EXISTS Artists
(
    artist_id           int             primary key AUTO_INCREMENT,
    first_name          varchar(50)     NOT NULL,
    last_name           varchar(50)     NOT NULL,
    artist_name         varchar(100)    NOT NULL,
    email               varchar(100)    NOT NULL UNIQUE,
    monthly_listener_count int
);

CREATE TABLE IF NOT EXISTS Venues
(
    venue_id            int             primary key AUTO_INCREMENT,
    venue_name          varchar(100)    NOT NULL UNIQUE,
    venue_hours         varchar(200),
    capacity            int             NOT NULL,
    city                varchar(100)    NOT NULL,
    state               varchar(100)    NOT NULL,
    zip                 varchar(10)     NOT NULL
);

CREATE TABLE IF NOT EXISTS VenueManagers
(
    venue_manager_id    int             primary key AUTO_INCREMENT,
    first_name          varchar(50)     NOT NULL,
    last_name           varchar(50)     NOT NULL,
    email               varchar(100)    NOT NULL UNIQUE,
    venue_id            int             NOT NULL,
    CONSTRAINT venue_managers_venue_constraint
        FOREIGN KEY (venue_id) REFERENCES Venues (venue_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS Concerts
(
    concert_id          int             primary key AUTO_INCREMENT,
    ticket_price        double          NOT NULL,
    sold_out            bool            NOT NULL DEFAULT FALSE,
    show_date           date            NOT NULL,
    has_happened        bool            NOT NULL DEFAULT (CURRENT_TIMESTAMP > show_date),
    link_to_tickets     varchar(200),
    venue_id            int             NOT NULL,
    CONSTRAINT concerts_venue_constraint
        FOREIGN KEY (venue_id) REFERENCES Venues (venue_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS FriendBridge
(
    user_id              int,
    friend_id            int,
    primary key(user_id, friend_id),
    CONSTRAINT friends_user_constraint
        FOREIGN KEY (user_id) REFERENCES TraditionalUsers (user_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT friends_friend_constraint
        FOREIGN KEY (friend_id) REFERENCES TraditionalUsers (user_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS AttendsBridge
(
    user_id              int,
    concert_id           int,
    primary key(user_id, concert_id),
    CONSTRAINT attends_user_constraint
        FOREIGN KEY (user_id) REFERENCES TraditionalUsers (user_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT attends_concert_constraint
        FOREIGN KEY (concert_id) REFERENCES Concerts (concert_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS FavoritesBridge
(
    user_id              int,
    concert_id           int,
    primary key(user_id, concert_id),
    CONSTRAINT favorites_user_constraint
        FOREIGN KEY (user_id) REFERENCES TraditionalUsers (user_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT favorites_concert_constraint
        FOREIGN KEY (concert_id) REFERENCES Concerts (concert_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS PerformsBridge
(
    artist_id               int,
    concert_id              int,
    set_list_length         int,
    is_headliner            bool NOT NULL,
    primary key(artist_id, concert_id),
    CONSTRAINT performs_user_constraint
        FOREIGN KEY (artist_id) REFERENCES Artists (artist_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT performs_concert_constraint
        FOREIGN KEY (concert_id) REFERENCES Concerts (concert_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS PreferredGenresBridge
(
    user_id                 int,
    genre_id                int,
    primary key(user_id, genre_id),
    CONSTRAINT preferred_genres_user_constraint
        FOREIGN KEY (user_id) REFERENCES TraditionalUsers (user_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT preferred_genres_genre_constraint
        FOREIGN KEY (genre_id) REFERENCES Genres (genre_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

CREATE TABLE IF NOT EXISTS ArtistGenresBridge
(
    artist_id               int,
    genre_id                int,
    primary key(artist_id, genre_id),
    CONSTRAINT artist_genres_artist_constraint
        FOREIGN KEY (artist_id) REFERENCES Artists (artist_id)
            ON DELETE CASCADE ON UPDATE CASCADE,
    CONSTRAINT artist_genres_genre_constraint
        FOREIGN KEY (genre_id) REFERENCES Genres (genre_id)
            ON DELETE CASCADE ON UPDATE CASCADE
);

INSERT INTO Genres (genre_id, genre_name) VALUES
                                              (1, 'Rock'), (2, 'Pop'), (3, 'Indie'), (4, 'Country'), (5, 'EDM'),
                                              (6, 'Blues'), (7, 'Jazz'), (8, 'Latin'), (9, 'Screamo'), (10, 'Metal'),
                                              (11, 'Swing'), (12, 'Folk'), (13, 'Americana'), (14, 'Hip Hop'), (15, 'Rap'),
                                              (16, 'Funk'), (17, 'R&B'), (18, 'Techno'), (19, 'Reggae'),
                                              (20, 'Classical'), (21, 'Soul'), (22, 'Grunge'), (23, 'Punk'),
                                              (24, 'Psychedelic'), (25, 'Hyper-pop'), (26, 'Alternative'),
                                              (27, 'Bluegrass');

INSERT INTO Venues (venue_id, venue_name, venue_hours,
                    capacity, city, state, zip) VALUES
                                                    (1, 'The 9:30 Club', 'Mon-Fri: 5pm-11pm, Sat-Sun: 5pm-2am', 1200,
                                               'Washington', 'District of Columbia', '20001'),
                                                    (2, 'The Anthem', 'Mon-Fri: 3pm-11pm, Sat-Sun: 6pm-2am', 6000,
                                               'Washington', 'District of Columbia', '20024'),
                                                    (3, 'The Sinclair', 'Mon-Fri: 4pm-11pm, Sat-Sun: 8pm-12am', 525,
                                               'Cambridge', 'Massachusetts', '02138'),
                                                    (4, 'Brinstar', NULL, 60,
                                               'Allston', 'Massachusetts', '02134'),
                                                    (5, 'MGM Music Hall', 'Mon-Fri: 8pm-11pm, Sat-Sun: 7pm-12am', 5000,
                                               'Cambridge', 'Massachusetts', '02215'),
                                                    (6, 'BB&T Pavilion', 'Mon-Fri: 9am-6pm, Sat-Sun: 8pm-12am', 25000,
                                               'Camden', 'New Jersey', '08103');
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (7,'Bitwolf','4:36 AM',4738,'Saint Louis','Missouri',7);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (8,'Lotstring','11:51 PM',2133,'Washington','District of Columbia',8);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (9,'Viva','4:36 AM',510,'Whittier','California',20062);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (10,'Tampflex','3:26 PM',5231,'Tampa','Florida',66);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (11,'Tempsoft','6:06 AM',2810,'Harrisburg','Pennsylvania',4636);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (12,'Keylex','5:33 AM',7867,'Boston','Massachusetts',23932);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (13,'Flexidy','3:27 PM',4378,'Burbank','California',06);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (14,'Asoka','2:59 AM',6619,'Dallas','Texas',2);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (15,'Sub-Ex','2:40 AM',8228,'Denver','Colorado',612);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (16,'Stim','8:00 PM',8017,'College Station','Texas',94);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (17,'Aerified','4:17 PM',1865,'Canton','Ohio',937);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (18,'Opela','12:05 AM',3535,'Springfield','Massachusetts',702);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (19,'Redhold','9:20 PM',1361,'Las Vegas','Nevada',31106);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (20,'TempsoftTwo','12:53 AM',8650,'Washington','District of Columbia',5869);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (21,'Home Ing','5:58 PM',2741,'Houston','Texas',8);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (22,'Subin','3:45 AM',6147,'Washington','District of Columbia',59);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (23,'Konklab','9:17 PM',5670,'Washington','District of Columbia',2796);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (24,'Bigtax','6:24 PM',4770,'Longview','Texas',5950);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (25,'Latlux','11:40 AM',4586,'Jacksonville','Florida',97);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (26,'SubinTwo','7:44 AM',3280,'Richmond','Virginia',0);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (27,'Home Ing Special','1:55 PM',6164,'Charlotte','North Carolina',84);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (28,'Greenhold','6:41 AM',2968,'Tulsa','Oklahoma',7);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (29,'Treeflex','2:28 AM',4542,'Amarillo','Texas',67);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (30,'Tres-Zap','10:53 AM',1093,'Gatesville','Texas',170);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (31,'Fewstrings','10:19 AM',3004,'Saint Paul','Minnesota',8987);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (32,'Zaam-Dox','4:49 PM',2717,'Troy','Michigan',5462);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (33,'Y-Solowarm','4:45 AM',343,'Montgomery','Alabama',047);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (34,'Greenlam','6:20 AM',6370,'Portland','Oregon',7);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (35,'Zamit','1:14 AM',8847,'Milwaukee','Wisconsin',32);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (36,'Fintone','6:57 AM',1943,'Springfield','Illinois',80);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (37,'It','7:57 PM',6679,'Pittsburgh','Pennsylvania',02);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (38,'Lotlux','9:57 AM',2320,'Charlotte','North Carolina',46);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (39,'Otcom','5:19 PM',859,'Anaheim','California',1125);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (40,'Bytecard','10:03 PM',8405,'Washington','District of Columbia',82);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (41,'Voyatouch','8:16 PM',8639,'Hartford','Connecticut',27);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (42,'Kilobytecard','4:34 AM',6132,'Largo','Florida',6919);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (43,'Veribet','1:55 AM',1549,'Dayton','Ohio',49);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (44,'Pannier','8:14 AM',7892,'Lexington','Kentucky',92035);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (45,'Holdlamis','3:52 AM',1835,'Tallahassee','Florida',4);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (46,'Rubberflex','12:16 PM',8709,'Portland','Oregon',9100);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (47,'Yellowhold','3:52 AM',5634,'Kansas City','Missouri',6829);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (48,'Sonair','12:53 AM',7491,'Gadsden','Alabama',98);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (49,'Voltsillam','5:19 AM',4147,'San Antonio','Texas',99853);
INSERT INTO Venues(venue_id,venue_name,venue_hours,capacity,city,state,zip) VALUES (50,'Stringtough','8:13 AM',6898,'Washington','District of Columbia',4915);

INSERT INTO VenueManagers (venue_manager_id, first_name,
                           last_name, email, venue_id) VALUES
                                                           (1, 'John', 'Hancock', 'jhancock@gmail.com', 1),
                                                           (2, 'Dave', 'Ham', 'iloveham@ham.com', 2),
                                                           (3, 'Bob', 'Duncan', 'goodluckcharlie@yahoo.com', 3),
                                                           (4, 'Jane', 'Janison', 'jjjj@jj.com', 4),
                                                           (5, 'Carly Rae', 'Jepsen', 'callme@maybe.com', 5),
                                                           (6, 'Mark', 'Fontenot', 'dontbelate@gmail.com', 6);

INSERT INTO Artists (artist_id, first_name,
                     last_name, artist_name, email,
                     monthly_listener_count) VALUES
                                                 (1, 'Lindsey', 'Jordan', 'Snail Mail', 'snail@mail.com', 679554),
                                                 (2, 'Andrew', 'Bird', 'Andrew Bird', 'abird@gmail.com', 1444844),
                                                 (3, 'Riley', 'King', 'B.B. King', 'bluestime@aol.com', 3334273),
                                                 (4, 'David', 'Marley', 'Ziggy Marley', 'dragonfly@gmail.com', 1467304),
                                                 (5, 'Gillian', 'Welch', 'Gillian Welch', 'msohio@gmail.com', 776508),
                                                 (6, 'David', 'Rawlings', 'Dave Rawlings Machine', 'daver@mach.com', 77340),
                                                 (7, 'Sonny', 'Moore', 'Skrillex', 'smoore@mix.com', 22364213),
                                                 (8, 'Kendrick', 'Duckworth', 'Kendrick Lamar', 'lucy@gmail.com', 43462595),
                                                 (9, 'Hannah', 'Read', 'Lomelda', 'hannah@sun.com', 1314363),
                                                 (10, 'Caroline', 'Rose', 'Caroline Rose', 'carose@gmail.com', 922720),
                                                 (11, 'Odie', 'Leigh', 'Odie Leigh', 'odie@folk.com', 199559),
                                                 (12, 'Stevland', 'Morris', 'Stevie Wonder', 'stevie@gmail.com', 17989869),
                                                 (13, 'Mena', 'Lemos', 'Trash Rabbit', 'trabbit@gmail.com', 789),
                                                 (14, 'Mei', 'Semones', 'Mei Semones', 'meisemones@gmail.com', 45685),
                                                 (15, 'Matt', 'Stephenson', 'Machine Girl', 'machine@girl.com', 1181735),
                                                 (16, 'Joan', 'Larkin', 'Joan Jet', 'joan@blackheart.com', 6633531),
                                                 (17, 'Isis', 'Gaston', 'Ice Spice', 'icespice@gmail.com', 38003141),
                                                 (18, 'Dolly', 'Parton', 'Dolly Parton', 'jolene@aol.com', 12777302),
                                                 (19, 'Laufey', 'Jonsdottir', 'Laufey', 'bigfan@cello.com', 3172943),
                                                 (20, 'Laura', 'Les', '100 gecs', 'toomanygecs@gmail.com', 3007724);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (21,'Kub, Tromp and Zulauf','Aimee','Kenworthy','akenworthyk@springer.com',13273024);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (22,'Krajcik Inc','Rhys','Lanchbury','rlanchburyl@narod.ru',3608957);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (23,'Prosacco-Ryan','Minni','Edgeworth','medgeworthm@blogtalkradio.com',5039513);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (24,'Kshlerin, Beier and Grimes','Niven','Jedrachowicz','njedrachowiczn@surveymonkey.com',3792152);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (25,'Klocko, Hartmann and D''Amore','Rik','Houtbie','rhoutbieo@sbwire.com',9142348);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (26,'Kuhlman and Sons','Valentino','Nightingale','vnightingalep@example.com',11181314);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (27,'Wiegand, Greenholt and Bahringer','Kerri','Blunt','kbluntq@about.com',17064811);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (28,'Torphy Inc','Suzanne','Siflet','ssifletr@twitpic.com',14245397);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (29,'Weber, Kub and Greenholt','Jameson','Castle','jcastles@amazon.de',15590598);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (30,'Marks, Thompson and Rempel','Viviana','Lowrie','vlowriet@odnoklassniki.ru',6258335);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (31,'Schaden-Vandervort','Lorilee','Reucastle','lreucastleu@prlog.org',17165183);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (32,'Wilkinson Inc','Ryann','Marking','rmarkingv@army.mil',902618);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (33,'Cruickshank-Herzog','Georgy','Pettie','gpettiew@statcounter.com',1162361);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (34,'Howe-Boehm','Noella','Pedrocchi','npedrocchix@scientificamerican.com',7422007);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (35,'Schuster-Koch','Mahmud','Lashmar','mlashmary@trellian.com',12707037);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (36,'Olson LLC','Carie','Sheering','csheeringz@skyrock.com',13365978);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (37,'Ferry, Schmitt and Kuhlman','Tabb','Skein','tskein10@tamu.edu',15758108);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (38,'Nader-Hegmann','Shea','Burnham','sburnham11@usda.gov',3926352);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (39,'Kunde, Walter and Fadel','Sadella','Mallebone','smallebone12@google.de',2919441);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (40,'Fisher Group','Maddie','De Ath','mdeath13@oracle.com',7965418);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (41,'Maggio-Funk','Sammy','Sullly','ssullly14@dell.com',10329911);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (42,'Hartmann LLC','Benoite','Woodman','bwoodman15@posterous.com',13633612);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (43,'Nader-Conn','Tracie','Kemet','tkemet16@livejournal.com',9771707);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (44,'Terry-Schinner','Ado','Silkston','asilkston17@mapquest.com',19352434);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (45,'Beier, Buckridge and Bartoletti','Rosemarie','Rosengren','rrosengren18@nsw.gov.au',413140);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (46,'Rutherford, Parisian and Lakin','Lemmy','Wych','lwych19@ebay.co.uk',4061011);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (47,'O''Reilly-Kiehn','Leena','Ferroni','lferroni1a@dagondesign.com',18000294);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (48,'Conn-Johnson','Noll','Cundey','ncundey1b@scribd.com',9788797);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (49,'Hansen-Homenick','Kristian','Margrem','kmargrem1c@pcworld.com',10667435);
INSERT INTO Artists(artist_id,artist_name,first_name,last_name,email,monthly_listener_count) VALUES (50,'Smitham, Murazik and Gutkowski','Augie','Corpe','acorpe1d@chicagotribune.com',7599077);

INSERT INTO ArtistGenresBridge (artist_id, genre_id) VALUES (1, 1), (1, 2), (1, 3),
                                                            (2, 26), (2, 2), (2, 20),
                                                            (3, 6),
                                                            (4, 19),
                                                            (5, 4), (5, 12), (5, 27),
                                                            (6, 4), (6, 12), (6, 27),
                                                            (7, 5),
                                                            (8, 14), (8, 15),
                                                            (9, 2), (9, 3), (9, 26),
                                                            (10, 1), (10, 2), (10, 3), (10, 26),
                                                            (11, 3), (11, 12),
                                                            (12, 2), (12, 16), (12, 21),
                                                            (13, 1), (13, 23),
                                                            (14, 3), (14, 20), (14, 7),
                                                            (15, 18), (15, 25), (15, 5),
                                                            (16, 1), (16, 23),
                                                            (17, 15), (17, 2),
                                                            (18, 4), (18, 2),
                                                            (19, 2), (19, 20), (19, 7),
                                                            (20, 25);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (21,22);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (22,4);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (23,2);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (24,16);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (25,22);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (26,8);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (27,4);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (28,7);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (29,6);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (30,15);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (31,8);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (32,3);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (33,9);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (34,10);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (35,26);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (36,19);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (37,11);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (38,5);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (39,5);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (40,17);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (41,24);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (42,13);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (43,7);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (44,18);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (45,27);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (46,6);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (47,17);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (48,20);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (49,10);
INSERT INTO ArtistGenresBridge(artist_id,genre_id) VALUES (50,26);

INSERT INTO TraditionalUsers (user_id, first_name,
                              last_name, email, city,
                              state, zip) VALUES
                                              (1, 'Gilad', 'Avni-Heller', 'gilavniheller@gmail.com',
                                               'Washington', 'District of Columbia', '20015'),
                                              (2, 'Stephen', 'Grello', 'grello.s@husky.neu.edu',
                                               'Camden', 'New Jersey', '08105'),
                                              (3, 'Phi', 'Garcia', 'phigarcia@gmail.com',
                                               'Newark', 'New Jersey', '07102'),
                                              (4, 'Aleksei', 'Shashilov', 'aleshashilov25@gmail.com',
                                               'Roxbury', 'Massachusetts', '02120'),
                                              (5, 'Mark', 'Fontenot', 'mfontenot@northeastern.edu',
                                               'Cambridge', 'Massachusetts', '02168'),
                                              (6, 'Jermayne', 'Sandwich', 'jsandwich0@photobucket.com',
                                               'Bethesda', 'Maryland', '20003'),
                                              (7, 'Jakie', 'Cromar', 'jcromar1@myspace.com',
                                               'Dartmouth', 'Massachusetts', '02715'),
                                              (8, 'Eadie', 'Imlin', 'eimlin2@illinois.edu',
                                               'Waltham', 'Massachusetts', '02156'),
                                              (9, 'Andriette', 'Southon', 'asouthon3@yellowbook.com',
                                               'Alexandria', 'Virginia', '20134'),
                                              (10, 'Giselbert', 'Leer', 'gleer4@army.mil',
                                               'New York City', 'New York', '10002'),
                                              (11, 'Gladys', 'Yarnold', 'gyarnold5@goo.gl',
                                               'Brooklyn', 'New York', '10017'),
                                              (12, 'Olympe', 'Drayn', 'odrayn6@imdb.com',
                                               'Providence', 'Rhode Island', '43029'),
                                              (13, 'Adolphe', 'Panchin', 'apanchin7@multiply.com',
                                               'Providence', 'Rhode Island', '43028'),
                                              (14, 'Mil', 'Riseam', 'mriseam8@ask.com',
                                               'Brooklyn', 'New York', '10019'),
                                              (15, 'Irene', 'Stubbe', 'istubbe9@mediafire.com',
                                               'Alexandria', 'Virginia', '20134'),
                                              (16, 'Currey', 'Borer', 'cborera@accuweather.com',
                                               'Potomac', 'Maryland', '20019'),
                                              (17, 'Sarene', 'Buchanon', 'sbukacb@mapy.cz',
                                               'Roxbury', 'Massachusetts', '02120'),
                                              (18, 'Ryun', 'De Gouy', 'rdegouyc@cyberchimps.com',
                                               'Dallas', 'Texas', '58103'),
                                              (19, 'Latrina', 'Corner', 'lcornerd@xing.com',
                                               'Austin', 'Texas', '58312'),
                                              (20, 'Valli', 'Duding', 'vdudinge@yahoo.co.jp',
                                               'Austin', 'Texas', '58395'),
                                              (21, 'Wilmette', 'Basile', 'wbasilef@washingtonpost.com',
                                               'Seattle', 'Washington', '93103'),
                                              (22, 'Kass', 'Figures', 'kfiguresg@unblog.fr',
                                               'San Francisco', 'California', '55490'),
                                              (23, 'Jacinta', 'Leadbitter', 'jleadbitterh@state.gov',
                                               'Berkeley', 'California', '55412'),
                                              (24, 'Jose', 'Wintringham', 'jwintringhami@columbia.edu',
                                               'Annapolis', 'Maryland', '20122'),
                                              (25, 'Anita', 'Ksandra', 'aksandraj@cmu.edu',
                                               'Cedar Falls', 'Iowa', '75003');
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (26,'Tova','Kemetz','tkemetzp@yellowpages.com','Gulfport','Mississippi',640);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (27,'Carmine','Paget','cpagetq@qq.com','Shreveport','Louisiana',050);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (28,'Nicky','Costello','ncostellor@tripadvisor.com','Salt Lake City','Utah',16);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (29,'Karisa','Vyel','kvyels@mozilla.com','Oklahoma City','Oklahoma',930);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (30,'Rodolfo','Ellings','rellingst@pagesperso-orange.fr','Pasadena','California',90);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (31,'Shelli','Woolley','swoolleyu@desdev.cn','Hayward','California',9);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (32,'Giff','Wilne','gwilnev@about.me','Melbourne','Florida',81504);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (33,'Joela','Tebald','jtebaldw@dailymotion.com','Austin','Texas',03);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (34,'Dana','Works','dworksx@shareasale.com','Minneapolis','Minnesota',11404);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (35,'Nesta','Warham','nwarhamy@123-reg.co.uk','Oklahoma City','Oklahoma',7700);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (36,'Savina','Maling','smalingz@4shared.com','Bowie','Maryland',475);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (37,'Halsy','Cartmel','hcartmel10@ucoz.ru','Atlanta','Georgia',82);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (38,'Milton','Stripp','mstripp11@umich.edu','Lawrenceville','Georgia',8724);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (39,'Zebadiah','Smitton','zsmitton12@facebook.com','Montgomery','Alabama',9);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (40,'Emmott','Birkwood','ebirkwood13@fda.gov','Dayton','Ohio',9);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (41,'Abdel','Westcar','awestcar14@jiathis.com','Raleigh','North Carolina',5823);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (42,'Mary','Thebe','mthebe15@cbsnews.com','Macon','Georgia',7);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (43,'Araldo','Feaster','afeaster16@opensource.org','Miami','Florida',81);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (44,'Datha','Price','dprice17@spiegel.de','Fayetteville','North Carolina',9160);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (45,'Rutherford','Hardingham','rhardingham18@people.com.cn','Saginaw','Michigan',357);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (46,'Alleyn','Klemensiewicz','aklemensiewicz19@upenn.edu','Phoenix','Arizona',6578);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (47,'Barbee','Andre','bandre1a@scribd.com','Denver','Colorado',3915);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (48,'Maurice','Truckett','mtruckett1b@histats.com','Akron','Ohio',8);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (49,'Jada','Gavin','jgavin1c@storify.com','Roanoke','Virginia',42239);
INSERT INTO TraditionalUsers(user_id,first_name,last_name,email,city,state,zip) VALUES (50,'Zenia','Gantley','zgantley1d@cocolog-nifty.com','Naples','Florida',17);

INSERT INTO Concerts (concert_id, ticket_price,
                      show_date, link_to_tickets,
                      venue_id) VALUES
                                    (1, 24.99, '2020-04-23', NULL, 1),
                                    (2, 19.99, '2021-05-02', NULL, 1),
                                    (3, 59.99, '2022-11-04', NULL, 2),
                                    (4, 62.99, '2023-07-25', 'https://andrewbirdtour.com/tickets', 2),
                                    (5, 24.99, '2023-08-12', 'https://skrillex.com/tour/tickets', 3),
                                    (6, 24.99, '2021-01-15', 'https://lomelda2021tour.com', 3),
                                    (7, 24.99, '2023-06-02', NULL, 4),
                                    (8, 24.99, '2023-05-15', NULL, 4),
                                    (9, 24.99, '2023-06-01', 'https://dollytour.com/buy/tickets', 5),
                                    (10, 24.99, '2023-02-26', 'https://thekingofblues.net/tour2023', 5),
                                    (11, 93.99, '2023-10-12', 'https://kendrick.com/tickets', 6),
                                    (12, 93.99, '2023-10-13', 'https://kendrick.com/tickets', 6);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (13,32.82,'2024-12-20','https://bravesites.com',9);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (14,79.71,'2016-05-30','https://biglobe.ne.jp',8);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (15,90.44,'2015-01-07','http://ehow.com',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (16,9.37,'2025-10-04','http://t-online.de',12);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (17,50.9,'2019-09-29','http://senate.gov',26);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (18,69.46,'2017-06-08','https://flickr.com',9);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (19,91.82,'2014-12-11','https://bbc.co.uk',20);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (20,47.87,'2018-07-17','http://studiopress.com',16);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (21,18.24,'2016-07-07','https://time.com',40);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (22,73.71,'2014-05-30','https://behance.net',49);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (23,15.43,'2015-07-22','http://wufoo.com',36);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (24,83.57,'2023-01-21','https://elpais.com',13);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (25,99.73,'2022-11-26','http://umn.edu',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (26,70.69,'2023-04-10','http://sina.com.cn',24);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (27,17.34,'2017-03-16','http://cyberchimps.com',26);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (28,53.67,'2020-12-22','http://timesonline.co.uk',32);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (29,10.66,'2014-10-24','http://amazon.co.jp',46);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (30,24.21,'2016-10-30','http://google.de',48);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (31,48.14,'2018-03-11','http://intel.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (32,84.98,'2019-03-27','http://freewebs.com',25);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (33,90.28,'2019-07-23','http://scribd.com',7);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (34,19.25,'2023-08-21','https://va.gov',32);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (35,32.31,'2021-04-05','http://ted.com',8);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (36,10.07,'2021-02-09','http://yelp.com',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (37,63.26,'2022-07-25','http://tiny.cc',19);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (38,98.07,'2026-07-31','http://wisc.edu',29);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (39,90.37,'2022-09-12','http://newyorker.com',46);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (40,28.82,'2026-11-27','http://howstuffworks.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (41,83.33,'2024-12-01','http://wunderground.com',40);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (42,60.45,'2026-07-21','https://narod.ru',47);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (43,76.1,'2015-06-03','https://huffingtonpost.com',10);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (44,26.47,'2023-05-27','https://sakura.ne.jp',3);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (45,87.19,'2025-09-03','https://bigcartel.com',10);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (46,14.64,'2023-04-12','https://techcrunch.com',13);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (47,53.81,'2015-09-21','https://marriott.com',18);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (48,92.07,'2025-01-29','https://gizmodo.com',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (49,77.53,'2021-07-03','https://bbc.co.uk',36);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (50,13.68,'2022-12-29','http://dion.ne.jp',40);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (51,84.8,'2016-07-06','http://rakuten.co.jp',28);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (52,49.94,'2017-07-26','http://vimeo.com',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (53,17.09,'2022-11-01','https://meetup.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (54,97.03,'2014-05-26','http://cam.ac.uk',9);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (55,85.3,'2023-05-15','https://ezinearticles.com',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (56,85.84,'2019-08-26','https://phpbb.com',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (57,73.55,'2026-09-17','http://histats.com',36);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (58,19.5,'2018-12-03','http://ucoz.ru',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (59,18.26,'2025-10-26','http://tinyurl.com',42);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (60,9.13,'2026-12-29','https://washington.edu',9);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (61,40.26,'2016-03-10','https://angelfire.com',18);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (62,31.05,'2019-05-19','https://instagram.com',15);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (63,60.11,'2021-04-17','https://japanpost.jp',26);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (64,40.78,'2020-08-21','http://diigo.com',2);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (65,94.52,'2024-03-20','https://ucoz.ru',46);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (66,78.86,'2025-12-14','http://clickbank.net',4);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (67,66.22,'2025-10-13','https://reddit.com',49);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (68,65.14,'2022-12-09','https://dedecms.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (69,11.82,'2021-11-07','http://live.com',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (70,28.7,'2017-08-21','https://smugmug.com',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (71,42.96,'2021-07-12','http://yandex.ru',38);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (72,93.35,'2016-06-12','http://sohu.com',24);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (73,45.03,'2016-09-28','http://economist.com',29);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (74,34.63,'2019-05-20','http://irs.gov',27);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (75,51.42,'2021-11-20','https://technorati.com',12);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (76,84.77,'2016-01-06','https://shutterfly.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (77,70.2,'2018-11-22','https://hhs.gov',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (78,32.58,'2014-07-13','http://timesonline.co.uk',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (79,87.1,'2016-05-28','http://infoseek.co.jp',28);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (80,41.92,'2020-06-10','http://taobao.com',15);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (81,34.95,'2017-08-04','https://privacy.gov.au',49);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (82,13.82,'2019-10-29','http://quantcast.com',10);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (83,35.35,'2014-09-18','http://ovh.net',46);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (84,9.62,'2015-05-29','http://canalblog.com',7);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (85,46.73,'2017-02-12','http://nhs.uk',25);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (86,30.14,'2025-12-31','https://gmpg.org',17);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (87,84.28,'2015-01-20','https://businesswire.com',46);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (88,39.88,'2014-12-07','https://instagram.com',30);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (89,71.55,'2024-05-07','http://facebook.com',4);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (90,42.53,'2022-01-18','https://opera.com',18);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (91,99.97,'2025-05-31','https://cnn.com',1);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (92,54.84,'2019-12-01','http://joomla.org',5);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (93,81.2,'2021-01-19','https://ca.gov',1);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (94,31.24,'2025-10-14','http://slideshare.net',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (95,32.58,'2015-03-25','http://amazon.co.jp',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (96,89.92,'2021-06-29','http://imgur.com',11);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (97,98.1,'2015-12-19','https://myspace.com',4);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (98,35.66,'2020-11-23','https://360.cn',21);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (99,19.96,'2014-04-02','http://hostgator.com',7);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (100,95.12,'2025-02-07','https://instagram.com',49);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (101,12.77,'2026-06-23','https://a8.net',5);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (102,42.95,'2014-04-30','https://bizjournals.com',24);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (103,69.94,'2014-09-01','https://yale.edu',14);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (104,73.52,'2025-03-07','https://goodreads.com',15);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (105,93.77,'2026-08-22','https://bigcartel.com',33);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (106,48.76,'2016-04-03','https://house.gov',31);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (107,94.81,'2014-03-03','http://flavors.me',29);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (108,59.62,'2026-07-19','https://icio.us',38);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (109,30.48,'2015-08-02','https://phoca.cz',48);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (110,63.69,'2026-01-23','http://blogger.com',29);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (111,19.15,'2016-12-21','http://jugem.jp',27);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (112,82.74,'2017-09-11','http://slashdot.org',31);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (113,55.05,'2015-10-21','https://barnesandnoble.com',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (114,60.93,'2016-08-28','https://about.me',27);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (115,52.84,'2023-05-14','http://nasa.gov',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (116,58.32,'2026-12-16','http://squidoo.com',48);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (117,28.65,'2020-11-19','http://miitbeian.gov.cn',15);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (118,85.32,'2023-10-08','http://example.com',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (119,69.76,'2026-08-12','http://cbsnews.com',47);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (120,86.38,'2022-07-18','https://shutterfly.com',5);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (121,33.24,'2016-03-08','http://oakley.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (122,60.1,'2017-02-16','http://hexun.com',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (123,24.69,'2024-09-10','https://weebly.com',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (124,50.23,'2026-08-02','https://typepad.com',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (125,44.4,'2022-04-03','http://pcworld.com',36);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (126,15.65,'2014-08-13','http://loc.gov',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (127,75.71,'2017-11-06','http://engadget.com',40);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (128,77.85,'2020-10-16','http://netlog.com',48);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (129,24.77,'2014-03-13','https://canalblog.com',6);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (130,32.93,'2019-10-15','http://usda.gov',17);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (131,10.46,'2021-10-24','https://deviantart.com',50);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (132,82.18,'2024-11-12','http://cbsnews.com',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (133,22.73,'2014-09-23','https://ft.com',39);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (134,92.11,'2018-04-20','http://usda.gov',50);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (135,90.96,'2019-11-21','https://reference.com',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (136,50.39,'2025-11-09','https://ehow.com',16);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (137,45.63,'2023-10-06','https://mozilla.org',21);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (138,62.42,'2022-05-03','https://vistaprint.com',7);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (139,48.78,'2021-03-30','https://hubpages.com',11);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (140,93.46,'2015-01-14','https://cpanel.net',41);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (141,87.46,'2022-02-10','https://furl.net',17);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (142,89.7,'2024-09-18','http://berkeley.edu',30);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (143,82.78,'2017-02-28','http://techcrunch.com',16);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (144,79.52,'2021-05-17','https://vkontakte.ru',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (145,48.2,'2026-11-25','http://yandex.ru',39);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (146,18.09,'2016-01-13','https://walmart.com',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (147,88.22,'2022-12-08','https://live.com',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (148,83.25,'2023-12-18','https://nyu.edu',31);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (149,55.42,'2015-09-30','http://hibu.com',12);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (150,32.12,'2018-09-10','http://unblog.fr',26);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (151,30.57,'2022-12-22','https://vinaora.com',15);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (152,82.86,'2016-12-19','https://umn.edu',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (153,47.43,'2024-01-17','https://fc2.com',7);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (154,33.79,'2019-10-20','https://biblegateway.com',50);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (155,12.4,'2015-11-01','http://mysql.com',33);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (156,79.64,'2025-12-21','http://cnn.com',44);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (157,21.29,'2016-01-25','https://hud.gov',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (158,60.74,'2022-11-05','https://miitbeian.gov.cn',49);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (159,93.73,'2026-01-29','https://shareasale.com',34);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (160,39.94,'2023-05-04','https://ovh.net',37);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (161,34.25,'2020-10-06','https://odnoklassniki.ru',1);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (162,95.58,'2025-04-27','http://xinhuanet.com',24);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (163,45.39,'2020-12-08','http://hp.com',36);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (164,80.63,'2020-07-02','http://blogs.com',8);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (165,41.97,'2024-07-06','https://sciencedaily.com',28);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (166,90.47,'2018-07-10','https://tumblr.com',29);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (167,49.89,'2019-09-29','http://usnews.com',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (168,87.71,'2019-04-11','http://e-recht24.de',28);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (169,26.94,'2020-09-22','https://independent.co.uk',39);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (170,77.48,'2016-08-27','http://ucoz.ru',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (171,20.92,'2020-02-21','https://ovh.net',5);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (172,96.08,'2016-04-06','http://sciencedaily.com',8);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (173,43.2,'2017-10-30','http://webs.com',50);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (174,50.22,'2016-10-12','http://i2i.jp',22);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (175,14.5,'2021-03-03','http://ca.gov',33);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (176,54.33,'2016-01-22','http://bloglines.com',7);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (177,70.4,'2023-02-03','http://slideshare.net',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (178,68.24,'2025-05-06','http://bloomberg.com',41);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (179,31.12,'2025-10-01','https://examiner.com',20);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (180,71.27,'2026-05-07','http://opensource.org',30);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (181,82.78,'2024-08-24','https://cornell.edu',47);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (182,39.93,'2014-07-08','https://theglobeandmail.com',45);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (183,45.26,'2026-11-04','https://sciencedirect.com',27);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (184,32.26,'2023-09-15','https://huffingtonpost.com',17);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (185,66.1,'2024-07-27','https://ebay.co.uk',46);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (186,27.85,'2022-09-25','https://last.fm',17);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (187,34.44,'2016-03-03','http://booking.com',29);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (188,70.37,'2015-03-29','https://networkadvertising.org',2);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (189,76.93,'2023-05-13','http://telegraph.co.uk',9);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (190,66.73,'2014-07-24','http://pinterest.com',40);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (191,8.72,'2024-07-31','http://deliciousdays.com',36);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (192,34.37,'2022-02-09','https://cargocollective.com',17);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (193,32.34,'2026-07-04','http://omniture.com',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (194,36.55,'2018-11-08','http://stumbleupon.com',4);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (195,18.87,'2014-03-21','http://usatoday.com',15);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (196,85.07,'2023-10-07','http://bravesites.com',10);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (197,67.34,'2021-11-03','https://123-reg.co.uk',42);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (198,71.71,'2021-01-26','http://spiegel.de',35);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (199,85.75,'2025-06-18','http://simplemachines.org',23);
INSERT INTO Concerts(concert_id,ticket_price,show_date,link_to_tickets,venue_id) VALUES (200,83.98,'2020-06-08','https://opensource.org',8);

INSERT INTO FriendBridge (user_id, friend_id) VALUES
                                                  (1, 2),
                                                  (2, 3),
                                                  (1, 4),
                                                  (4, 9),
                                                  (13, 2),
                                                  (16, 15),
                                                  (24, 1),
                                                  (6, 7),
                                                  (8, 9),
                                                  (7, 8),
                                                  (6, 9),
                                                  (20, 21),
                                                  (4, 12),
                                                  (23, 6),
                                                  (10, 25),
                                                  (6, 3),
                                                  (6, 18),
                                                  (17, 14),
                                                  (11, 21),
                                                  (5, 15),
                                                  (15, 20);

INSERT INTO PreferredGenresBridge (user_id, genre_id) VALUES (1, 1), (1, 2), (1, 6),
                                                             (2, 9),
                                                             (3, 4), (3, 2), (3, 25),
                                                             (4, 7), (4, 8), (4, 26), (4, 19),
                                                             (5, 11),
                                                             (6, 14), (6, 15), (6, 9),
                                                             (7, 5), (7, 23), (7, 26),
                                                             (8, 20),
                                                             (9, 21), (9, 16), (9, 17),
                                                             (10, 22), (10, 10), (10, 9),
                                                             (11, 18), (11, 5),
                                                             (12, 19),
                                                             (13, 6), (13, 7), (13, 11),
                                                             (14, 11),
                                                             (15, 1), (15, 23),
                                                             (16, 4), (16, 13), (16, 8),
                                                             (17, 9),
                                                             (18, 9),
                                                             (19, 9),
                                                             (20, 25), (20, 19),
                                                             (21, 24), (21, 1), (21, 18),
                                                             (22, 26), (22, 22), (22, 23), (22, 11),
                                                             (23, 8),
                                                             (24, 5), (24, 4), (24, 3), (24, 6),
                                                             (25, 2);


INSERT INTO AttendsBridge (user_id, concert_id) VALUES (1, 1), (1, 3), (1, 9), (1, 12),
                                                       (4, 2), (4, 11),
                                                       (3, 12),
                                                       (5, 1), (5, 2), (5, 4), (5, 6), (5, 8), (5, 9), (5, 10),
                                                       (6, 1), (6, 3), (6, 6), (6, 7), (6, 8),
                                                       (7, 1), (7, 2), (7, 3), (7, 9), (7, 10),
                                                       (8, 4), (8, 6), (8, 8), (8, 10), (8, 11),
                                                       (9, 2), (9, 3), (9, 4), (9, 5), (9, 9), (9, 12),
                                                       (10, 1), (10, 3),
                                                       (11, 1), (11, 3), (11, 6), (11, 7),
                                                       (13, 1), (13, 11), (13, 12),
                                                       (14, 1), (13, 3), (13, 6), (13, 7), (13, 8),
                                                       (16, 1), (16, 3), (16, 6),
                                                       (17, 1), (17, 3), (17, 6), (17, 7), (17, 8), (17, 9), (17, 10),
                                                       (18, 2), (18, 3), (18, 4), (18, 5), (18, 6),
                                                       (19, 1), (19, 3), (19, 5), (19, 7), (19, 9),
                                                       (20, 8), (20, 10), (20, 11),
                                                       (21, 1), (21, 2), (21, 3), (21, 7), (21, 8), (21, 11),
                                                       (22, 4), (22, 5), (22, 6),
                                                       (23, 4), (23, 5), (23, 7), (23, 8), (23, 9),
                                                       (24, 3), (24, 10), (24, 12),
                                                       (25, 1), (25, 3), (25, 6), (25, 7), (25, 8), (25, 12);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (1,43);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (2,30);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (3,30);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (4,49);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (5,50);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (6,39);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (7,31);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (8,36);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (9,42);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (10,39);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (11,37);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (12,49);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (13,30);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (14,30);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (15,45);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (16,32);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (17,36);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (18,32);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (19,39);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (20,31);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (21,48);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (22,38);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (23,45);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (24,41);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (25,45);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (26,39);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (27,38);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (28,30);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (29,47);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (30,32);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (1,27);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (2,58);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (3,15);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (4,17);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (5,32);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (6,28);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (7,41);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (8,29);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (9,13);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (10,10);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (11,4);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (12,5);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (13,47);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (14,8);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (15,7);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (16,7);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (17,16);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (18,17);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (19,16);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (20,17);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (21,13);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (22,27);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (23,25);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (24,23);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (25,28);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (26,36);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (27,39);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (28,35);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (1,42);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (2,48);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (3,42);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (4,43);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (5,43);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (6,41);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (7,43);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (8,45);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (9,49);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (10,45);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (11,34);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (12,24);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (13,15);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (14,29);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (15,35);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (16,41);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (17,31);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (18,7);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (19,6);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (20,2);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (21,6);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (22,7);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (23,2);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (24,16);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (25,16);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (26,15);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (27,11);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (28,18);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (29,14);
INSERT INTO AttendsBridge(user_id,concert_id) VALUES (30,25);


INSERT INTO FavoritesBridge (user_id, concert_id) VALUES (2, 4), (2, 10), (2, 12),
                                                         (4, 4), (4, 5), (4, 7), (4, 8),
                                                         (5, 7),
                                                         (6, 5), (6, 11),
                                                         (7, 4),
                                                         (8, 5), (8, 11), (8, 12),
                                                         (9, 11),
                                                         (10, 5), (10, 10),
                                                         (11, 10),
                                                         (19, 10), (19, 11),
                                                         (20, 4), (20, 8),
                                                         (21, 10),
                                                         (24, 5), (24, 12);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (1,17);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (2,17);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (3,16);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (4,24);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (5,23);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (6,39);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (7,32);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (8,31);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (9,32);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (10,22);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (11,19);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (12,17);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (13,6);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (14,7);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (15,6);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (16,5);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (17,12);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (18,15);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (19,35);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (20,18);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (21,35);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (22,43);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (23,47);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (24,45);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (25,46);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (26,41);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (27,45);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (28,46);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (29,47);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (30,38);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (1,33);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (2,34);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (3,32);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (4,48);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (5,33);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (6,49);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (7,23);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (8,25);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (9,40);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (10, 13);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (11, 39);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (12,48);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (13,38);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (14,40);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (15,31);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (16,36);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (17,46);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (18,38);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (19,34);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (20,30);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (21,27);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (22,42);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (23,43);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (24,26);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (25,32);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (26,49);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (27,43);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (28,44);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (29,28);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (30,16);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (1,13);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (2,15);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (3,17);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (4,11);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (5,10);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (6,16);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (7,12);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (8,17);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (9,10);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (10,18);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (11,21);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (12,21);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (13,25);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (14,21);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (15,14);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (16,26);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (17,25);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (18,23);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (19,36);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (20,35);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (21,34);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (22,39);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (23,46);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (24,30);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (25,21);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (26,11);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (27,9);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (28,16);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (29,16);
INSERT INTO FavoritesBridge(user_id,concert_id) VALUES (30,44);

INSERT INTO PerformsBridge (artist_id, concert_id, set_list_length, is_headliner) VALUES (20, 1, 40, true),
                                                                                         (15, 1, 8, false),
                                                                                         (1, 2, 12, true),
                                                                                         (11, 2, 9, false),
                                                                                         (5, 3, 9, true),
                                                                                         (6, 3, 11, true),
                                                                                         (11, 3, 10, false),
                                                                                         (2, 4, 9, true),
                                                                                         (19, 4, 8, false),
                                                                                         (7, 5, 12, true),
                                                                                         (9, 6, 10, true),
                                                                                         (11, 6, 9, false),
                                                                                         (14, 7, 8, true),
                                                                                         (13, 7, 9, false),
                                                                                         (17, 8, 12, true),
                                                                                         (12, 8, 11, false),
                                                                                         (18, 9, 14, true),
                                                                                         (4, 9, 12, false),
                                                                                         (3, 10, 6, true),
                                                                                         (16, 10, 10, false),
                                                                                         (8, 11, 15, true),
                                                                                         (8, 12, 15, true);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (22,1,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,2,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,3,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,4,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (43,5,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,6,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (35,7,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,8,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,9,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,10,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,11,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (3,12,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,13,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,14,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,15,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (15,16,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (35,17,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,18,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,19,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,20,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,21,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,22,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,23,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (42,24,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,25,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (49,26,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,27,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,28,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,29,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,30,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,31,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,32,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,33,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,34,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,35,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,36,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,37,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (11,38,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,39,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,40,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,41,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,42,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,43,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,44,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,45,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,46,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,47,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,48,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,49,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,50,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (35,51,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,52,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,53,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (31,54,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,55,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,56,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,57,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,58,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,59,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,60,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,61,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,62,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,63,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,64,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,65,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,66,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,67,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,68,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,69,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,70,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,71,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,72,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,73,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,74,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,75,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,76,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,77,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,78,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,79,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,80,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,81,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,82,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,83,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,84,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,85,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,86,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,87,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (37,88,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,89,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,90,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,91,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,92,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,93,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (43,94,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,95,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,96,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (30,97,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,98,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,99,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,100,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,101,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,102,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,103,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,104,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (3,105,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (43,106,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,107,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,108,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,109,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,110,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,111,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,112,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,113,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,114,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (42,115,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,116,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,117,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,118,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,119,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,120,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,121,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (3,122,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,123,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,124,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,125,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,126,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,127,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,128,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,129,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,130,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,131,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,132,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (31,133,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,134,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,135,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,136,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,137,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,138,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,139,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,140,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,141,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (35,142,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,143,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (15,144,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,145,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,146,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,147,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,148,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,149,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (17,150,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,151,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,152,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,153,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,154,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,155,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,156,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (37,157,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,158,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,159,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,160,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (17,161,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,162,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,163,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,164,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,165,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,166,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,167,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (11,168,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,169,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,170,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (1,171,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,172,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,173,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,174,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (41,175,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,176,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (1,177,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,178,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,179,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,180,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,181,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,182,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,183,4,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,184,5,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,185,9,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,186,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,187,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,188,3,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,189,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,190,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (46,191,12,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (46,192,10,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,193,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,194,6,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,195,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,196,11,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,197,7,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,198,8,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (49,199,14,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,200,13,1);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (3,1,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,2,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,3,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,5,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,5,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,6,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (17,7,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,8,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,9,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,10,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,11,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,12,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (3,13,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,14,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (37,15,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,16,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,17,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,18,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,19,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,20,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (37,21,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (1,22,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,23,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,24,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,25,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,26,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,27,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,28,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,29,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,30,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,31,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (31,32,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,33,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,34,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,35,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,36,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,37,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,38,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,39,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,40,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (42,41,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,42,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,43,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,44,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,45,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (49,46,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,47,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,48,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,49,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,50,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,51,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,52,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,53,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,54,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (41,55,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,56,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,57,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,58,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,59,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,60,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,61,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,62,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,63,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,64,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,65,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (9,66,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,67,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,68,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,69,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (1,70,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,71,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,72,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (42,73,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,74,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,75,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (31,76,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,77,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (1,78,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,79,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (22,80,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,85,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,82,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,83,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,84,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,85,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,86,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (10,87,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (42,88,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (37,89,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (15,90,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,91,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,92,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,93,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,94,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,95,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,96,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (42,97,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (43,98,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,99,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,100,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (3,101,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,102,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,103,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,104,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (35,105,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,106,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (41,107,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,108,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (39,109,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,110,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,119,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,112,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (43,113,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,114,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,115,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,116,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,117,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (37,118,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,119,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,120,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,121,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,122,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,123,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,124,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (31,125,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (11,126,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,127,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,128,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,129,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (46,130,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,131,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,132,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (16,133,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,134,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,135,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (49,136,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (23,137,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (19,138,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,139,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,140,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,141,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (12,142,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (1,143,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,144,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,145,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,146,3,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (49,147,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,148,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,149,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,150,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (21,151,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,159,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (6,153,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,154,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (8,155,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (47,156,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,157,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,158,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (44,159,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,160,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,161,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,162,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,163,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (5,164,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (40,162,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (38,166,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,167,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (7,168,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (34,169,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,170,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (13,171,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,172,7,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,173,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,174,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,175,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (45,176,10,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,177,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (26,178,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,179,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (17,180,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (49,181,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (11,182,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (41,183,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (48,184,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,185,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (18,186,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (36,187,14,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (4,188,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (27,189,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,190,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (24,191,5,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (25,192,11,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (28,193,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (33,194,8,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (50,195,12,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (14,196,13,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (20,197,9,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (32,198,4,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (29,199,6,0);
INSERT INTO PerformsBridge(artist_id,concert_id,set_list_length,is_headliner) VALUES (2,200,9,0);