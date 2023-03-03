INSERT INTO managers 
SELECT manager_name, man_fam_name, man_mobile FROM fsdb.recordings WHERE man_mobile IS NOT NULL
UNION
SELECT manager_name, man_fam_name, man_mobile FROM fsdb.livesingings WHERE man_mobile IS NOT NULL;

INSERT INTO performers
SELECT DISTINCT coalesce(band, musician), nationality, nvl(band_language, 'unknown') FROM fsdb.artists;

INSERT INTO musicians
SELECT DISTINCT musician, passport, nationality, to_date(birthdate, 'DD-MM-YYYY') FROM fsdb.artists;

INSERT INTO tours
SELECT DISTINCT performer, tour FROM fsdb.livesingings WHERE tour IS NOT NULL;

INSERT INTO concerts
SELECT DISTINCT performer, to_date(when, 'DD-MM-YYYY'), tour, to_number(man_mobile), municipality, country, address, to_number(attendance), to_number(duration_min) FROM fsdb.livesingings WHERE man_mobile is not NULL and duration_min is not NULL;

INSERT INTO memberships 
SELECT passport,coalesce(band, musician),role, start_date,end_date FROM fsdb.artists;

INSERT INTO performed_songs 
SELECT DISTINCT song,writer, performer, to_date(when, 'DD-MM-YYYY'), cowriter, duration_min FROM fsdb.livesingings;

INSERT INTO albums
SELECT DISTINCT album_pair, release_date, format, publisher, album_title, performer, to_number(album_length), to_number(man_mobile) from fsdb.recordings;

INSERT INTO recorded_songs 
SELECT tracknum, album_pair, duration/60, song, writer, performer, to_date(rec_date,'DD-MM-YYYY'), engineer, studio,stud_address FROM fsdb.recordings WHERE album_pair IS NOT NULL;

INSERT INTO record_labels
SELECT DISTINCT publisher, pub_phone from fsdb.recordings WHERE publisher IS NOT NULL;

INSERT INTO attendees
SELECT DISTINCT dni, e_mail, name, surn1, surn2, birthdate, phone, address from fsdb.melomaniacs WHERE e_mail IS NOT NULL;

INSERT INTO attendance_sheets
SELECT performer, when, e_mail, birthdate, purchase, rfid FROM fsdb.melomaniacs WHERE rfid IS NOT NULL;