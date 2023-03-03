INSERT INTO managers 
SELECT DISTINCT manager_name, man_fam_name,man_mobile FROM fsdb.recordings WHERE man_mobile is not NULL 
UNION
SELECT DISTINCT  manager_name, man_fam_name,man_mobile FROM fsdb.livesingings WHERE man_mobile is not NULL;

INSERT INTO performers
SELECT distinct coalesce(band, musician), nationality, nvl(band_language, 'unknown') FROM fsdb.artists;

INSERT INTO musicians
SELECT distinct musician, passport, nationality, to_date(birthdate, 'DD-MM-YYYY') FROM fsdb.artists;

INSERT INTO tours
SELECT distinct performer, tour FROM fsdb.livesingings WHERE tour is not null;

INSERT INTO concerts
SELECT distinct performer, to_date(when, 'DD-MM-YYYY'), tour, to_number(man_mobile), municipality, country, address, nvl(to_number(attendance), 0), to_number(duration_min) FROM fsdb.livesingings 
WHERE man_mobile is not NULL and duration_min is not NULL;


INSERT INTO memberships 
SELECT passport,coalesce(band, musician),role, start_date,end_date FROM fsdb.artists;


INSERT INTO performed_songs 
SELECT DISTINCT song,writer, performer, to_date(when, 'DD-MM-YYYY'), cowriter, duration_min FROM fsdb.livesingings;

INSERT INTO albums
SELECT DISTINCT album_pair, release_date, format, publisher, album_title, performer, to_number(album_length), to_number(man_mobile) from fsdb.recordings WHERE album_pair is not null;

INSERT INTO recorded_songs 
SELECT DISTINCT tracknum, album_pair, duration/60, song, writer, performer, to_date(rec_date,'DD-MM-YYYY'), engineer, studio,stud_address FROM fsdb.recordings;


INSERT INTO record_labels
SELECT distinct publisher, pub_phone from fsdb.recordings WHERE publisher is not null;

INSERT INTO attendees
SELECT distinct dni, e_mail, name, surn1, surn2, birthdate, phone, address from fsdb.melomaniacs WHERE e_mail is not null;

INSERT INTO attendance_sheet
SELECT performer, when, e_mail, birthdate, purchase, rfid FROM fsdb.melomaniacs WHERE rfid is not null;