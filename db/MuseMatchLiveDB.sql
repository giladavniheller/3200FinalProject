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

SELECT Concerts.concert_id, A.artist_name, venue_name
FROM Concerts JOIN PerformsBridge PB on Concerts.concert_id = PB.concert_id
    JOIN Artists A on A.artist_id = PB.artist_id
    JOIN Venues V on Concerts.venue_id = V.venue_id
