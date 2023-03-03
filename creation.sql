drop TABLE managers cascade constraints;
drop TABLE memberships cascade constraints;
drop TABLE musicians cascade constraints;
drop TABLE concerts cascade constraints;
drop TABLE performers cascade constraints;
drop TABLE tours cascade constraints;
drop TABLE performed_songs cascade constraints;
drop TABLE recorded_songs cascade constraints;
drop TABLE albums cascade constraints;
drop TABLE record_labels cascade constraints;
drop TABLE attendance_sheets cascade constraints;
drop TABLE attendees cascade constraints;

CREATE TABLE performers(
	stage_name VARCHAR2(100) NOT NULL,
	registration_nationality VARCHAR2(20) NOT NULL,
	language VARCHAR2(20) NOT NULL,
	CONSTRAINT pk_performers PRIMARY KEY(stage_name)
);

CREATE TABLE managers(
	first_name VARCHAR2(35) NOT NULL,
	last_name VARCHAR2(20) NOT NULL,
	mobile_phone_number NUMBER(10) NOT NULL,
	CONSTRAINT pk_managers PRIMARY KEY(mobile_phone_number)
);


CREATE TABLE albums(
	pair CHAR(15) NOT NULL, 
	release_date DATE NOT NULL,
	format VARCHAR2(10) NOT NULL,
	record_label VARCHAR2(25) NOT NULL,
	title VARCHAR2(50) NOT NULL,
	album_performer VARCHAR2(50) NOT NULL,
	total_duration NUMBER(10) NOT NULL,
	manager NUMBER (10) NOT NULL, 
	CONSTRAINT pk_album PRIMARY KEY(pair),
	CONSTRAINT fk_album_album_performer FOREIGN KEY(album_performer) REFERENCES performers (stage_name), 
	CONSTRAINT fk_album_manager FOREIGN KEY (manager) REFERENCES managers (mobile_phone_number),
	CONSTRAINT valid_dur_album CHECK(total_duration > 0),
	CONSTRAINT valid_format_album CHECK (format IN ('Vynil','Single','CD','Streaming','Audio File','MP3'))
);


CREATE TABLE tours(
	performer VARCHAR2(100) NOT NULL,
	name VARCHAR2(100) NOT NULL,
	CONSTRAINT pk_tours PRIMARY KEY(performer, name)
);


CREATE TABLE concerts(
	performer VARCHAR2(100) NOT NULL,
	concert_date DATE NOT NULL,
	tour VARCHAR2(100),
	manager NUMBER(10) NOT NULL,
	municipality VARCHAR2(100) NOT NULL,
	country VARCHAR2(100) NOT NULL,
	venue_address VARCHAR2(100) NOT NULL,
	number_of_attendees NUMBER(7),
	total_duration NUMBER(3),
	CONSTRAINT pk_concerts PRIMARY KEY(performer, concert_date),
	CONSTRAINT fk_concerts_performers FOREIGN KEY(performer) REFERENCES performers(stage_name),
	CONSTRAINT fk_concerts_tours FOREIGN KEY(performer, tour) REFERENCES tours(performer, name),
	CONSTRAINT fk_concerts_managers FOREIGN KEY(manager) REFERENCES managers(mobile_phone_number),
	CONSTRAINT valid_number_of_attendees CHECK (number_of_attendees > -1)
);


CREATE TABLE musicians(
	name VARCHAR2(80) NOT NULL,
	passport VARCHAR2(14) NOT NULL,
	natural_nationality VARCHAR2(20) NOT NULL,
	date_of_birth DATE NOT NULL, 
	CONSTRAINT pk_musicians PRIMARY KEY(passport)
);


CREATE TABLE memberships(
	musician VARCHAR2(50) NOT NULL,
	performer VARCHAR2(50) NOT NULL,
	role VARCHAR2(15),
	date_of_incorporation DATE,
	date_of_withdrawal DATE,
	CONSTRAINT pk_memberships PRIMARY KEY(musician, performer),
	CONSTRAINT fk_memberships_musicians FOREIGN KEY(musician) REFERENCES musicians(passport) ON DELETE CASCADE,
	CONSTRAINT fk_memberships_performers FOREIGN KEY(performer) REFERENCES performers(stage_name) ON DELETE CASCADE
);

CREATE TABLE performed_songs(
	title VARCHAR2(100) NOT NULL,
	author1 VARCHAR2(100) NOT NULL,
	concert_performer VARCHAR2(100) NOT NULL,
	concert_date DATE NOT NULL,
	author2 VARCHAR2(100),
	duration NUMBER(4),
	CONSTRAINT pk_perf_song PRIMARY KEY(title,author1, concert_performer,concert_date),
	CONSTRAINT fk_perf_song_concert FOREIGN KEY(concert_performer,concert_date) REFERENCES concerts(performer,concert_date) ON DELETE CASCADE
);


CREATE TABLE recorded_songs(
	track_order NUMBER(3) NOT NULL,
	album CHAR(15) NOT NULL,
	duration NUMBER(4) NOT NULL,
	title VARCHAR2(50) NOT NULL,
	author VARCHAR2(50) NOT NULL,
	performer VARCHAR2(50) NOT NULL,
	recording_date DATE NOT NULL,
	recording_engineer VARCHAR2(50) NOT NULL,
	studio_name VARCHAR2(50),
	studio_address VARCHAR2(100),
	CONSTRAINT pk_rec_song PRIMARY KEY(author,album,title,track_order),
	CONSTRAINT fk_rec_song_album FOREIGN KEY(album) REFERENCES albums(pair) ON DELETE CASCADE,
	CONSTRAINT fk_rec_song_performer FOREIGN KEY(performer) REFERENCES performers(stage_name) ON DELETE CASCADE,
	CONSTRAINT pos_dur_rec_song CHECK(duration > 0),
	CONSTRAINT valid_dur_rec_song CHECK(duration < 90)
);


CREATE TABLE record_labels(
	name VARCHAR2(25) NOT NULL,
	phone_number NUMBER(10) NOT NULL,
	CONSTRAINT pos_pn_labels CHECK(phone_number > 0),
	CONSTRAINT pk_rec_label PRIMARY KEY (name)
);


CREATE TABLE attendees(
	passport VARCHAR2(14), 
	email VARCHAR2(100) NOT NULL,
	name VARCHAR2(80),
	surname1 VARCHAR2(80),
	surname2 VARCHAR2(80),
	date_of_birth DATE,
	telephone_number NUMBER(10),
	postal_address VARCHAR2(100),
	CONSTRAINT pk_attendees PRIMARY KEY (email)
);

CREATE TABLE attendance_sheets(
	concert_performer VARCHAR2(100) NOT NULL,
	concert_date DATE NOT NULL,
	attendee VARCHAR2(100) NOT NULL,
	date_of_birth DATE NOT NULL, 
	date_of_ticket_purchase DATE NOT NULL,
	rfid VARCHAR2(120) NOT NULL,
	CONSTRAINT pk_att_sheet PRIMARY KEY (rfid),
	CONSTRAINT fk_att_sheet_concert FOREIGN KEY(concert_performer,concert_date) REFERENCES concerts(performer,concert_date) ON DELETE CASCADE,
	CONSTRAINT fk_att_sheet_attendee FOREIGN KEY(attendee) REFERENCES attendees(email) ON DELETE CASCADE,
	CONSTRAINT CHECK_valid_age_att CHECK ((concert_date - date_of_birth) / 365 >= 18),
	CONSTRAINT chceck_valid_pur_att_1 CHECK (date_of_ticket_purchase < concert_date),
	CONSTRAINT chceck_valid_pur_att_2 CHECK (date_of_ticket_purchase > date_of_birth)
);