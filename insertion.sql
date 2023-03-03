truncate table performers;
truncate table musicians;
truncate table tours;
truncate table concerts;
truncate table memberships;
truncate table managers;
truncate table performed_songs;
truncate table recorded_songs;
truncate table albums;
truncate table record_labels;
truncate table attendees;
truncate table attendance_sheet;

INSERT INTO managers 
SELECT DISTINCT manager_name, man_fam_name,man_mobile FROM fsdb.recordings;

INSERT INTO performers
SELECT distinct coalesce(band, musician), nationality, band_language FROM fsdb.artists;

INSERT INTO musicians
SELECT distinct musician, passport, nationality, to_date(birthdate, 'DD-MM-YYYY') FROM fsdb.artists;

INSERT INTO tours
SELECT distinct performer, tour FROM fsdb.livesingings WHERE tour is not null;

INSERT INTO concerts (performer, concert_date)
SELECT distinct performer, to_date(when, 'DD-MM-YYYY'), /*tour, to_number(man_mobile), municipality, country, address, attendance, duration_min*/ FROM fsdb.livesingings;

INSERT INTO memberships 
SELECT musician, band,role,start_date,end_date FROM fsdb.artists WHERE band is NOT NULL;

INSERT INTO memberships 
SELECT musician, musician,role,start_date,end_date FROM fsdb.artists WHERE band is NULL;

INSERT INTO performed_songs 
SELECT song,writer, performer, to_date(when, 'dd-mm-yyyy'), cowriter, duration_min FROM fsdb.livesingings;

INSERT INTO recorded_songs 
SELECT tracknum, album_pair, duration, song, writer, performer, to_date(rec_date,'dd-mm-yyyy'), engineer, studio,stud_address;

INSERT INTO albums
SELECT album_pair, release_date, format, publisher, album_title, performer, album_length, manager_name from fsdb.recordings WHERE album_pair is not null;

INSERT INTO record_labels
SELECT distinct publisher, pub_phone from fsdb.recordings WHERE publisher is not null;

INSERT INTO attendees
SELECT distinct dni, e_mail, name, surn1, surn2, birthdate, phone, address from fsdb.melomaniacs WHERE e_mail is not null;

INSERT INTO attendance_sheet
SELECT performer, when, e_mail, birthdate, purchase, rfid FROM fsdb.melomaniacs WHERE rfid is not null;