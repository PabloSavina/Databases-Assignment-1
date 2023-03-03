drop table managers cascade constraints;
drop table memberships cascade constraints;
drop table musicians cascade constraints;
drop table concerts cascade constraints;
drop table performers cascade constraints;
drop table tours cascade constraints;
drop TABLE performed_songs cascade constraints;
drop TABLE recorded_songs cascade constraints;
drop TABLE albums cascade constraints;
drop TABLE record_labels cascade constraints;
drop TABLE attendance_sheet cascade constraints;
drop TABLE attendees cascade constraints;

create table performers(
	stage_name varchar2(100),
	registration_nationality varchar2(20),
	language varchar2(20),
	constraint pk_performers primary key(stage_name)
);

create table managers(
	first_name varchar2(35),
	last_name varchar2(20),
	mobile_phone_number number(10),
	constraint pk_managers primary key(mobile_phone_number)
);


CREATE TABLE albums(
	pair CHAR(15) NOT NULL, 
	release_date DATE NOT NULL,
	format VARCHAR2(10) NOT NULL,
	record_label VARCHAR2(25) NOT NULL,
	title VARCHAR2(50) NOT NULL,
	album_performer VARCHAR2(50) NOT NULL,
	total_duration NUMBER(3) NOT NULL,
	manager NUMBER (10), 
	CONSTRAINT pk_album PRIMARY KEY(pair),
	CONSTRAINT fk_album_album_performer FOREIGN KEY(album_performer) REFERENCES performers (stage_name), 
	CONSTRAINT fk_album_manager FOREIGN KEY (manager) REFERENCES managers (mobile_phone_number),
	CONSTRAINT valid_dur_album CHECK(total_duration > 0)
);


create table tours(
	performer varchar2(100),
	name varchar2(100),
	constraint pk_tours primary key(performer, name)
);


create table concerts(
	performer varchar2(100),
	concert_date date,
	tour varchar2(100),
	manager number(10),
	municipality varchar2(100),
	country varchar2(100),
	venue_address varchar2(100),
	number_of_attendees number(7),
	total_duration number(3),
	constraint pk_concerts primary key(performer, concert_date),
	constraint fk_concerts_performers foreign key(performer) references performers(stage_name),
	constraint fk_concerts_tours foreign key(performer, tour) references tours(performer, name),
	constraint fk_concerts_managers foreign key(manager) references managers(mobile_phone_number),
	constraint valid_number_of_attendees check (number_of_attendees > 0)
);


create table musicians(
	/*first_name varchar2(80), last_name varchar2(80),*/
	name varchar2(80),
	passport varchar2(14),
	natural_nationality varchar2(20),
	date_of_birth date,
	constraint pk_musicians primary key(passport)
);


create table memberships(
	musician varchar2(50),
	performer varchar2(50),
	role varchar2(15) NULL,
	date_of_incorporation date NULL,
	date_of_withdrawal date NULL,
	constraint pk_memberships primary key(musician, performer),
	constraint fk_memberships_musicians foreign key(musician) references musicians(passport) on delete cascade,
	constraint fk_memberships_performers foreign key(performer) references performers(stage_name) on delete cascade
);

CREATE TABLE performed_songs(
	title VARCHAR2(100),
	author1 VARCHAR2(100),
	concert_performer VARCHAR2(100),
	concert_date DATE,
	author2 VARCHAR2(100) NULL,
	duration NUMBER(4) NULL,
	CONSTRAINT pk_perf_song PRIMARY KEY(title,author1, concert_performer,concert_date),
	CONSTRAINT fk_perf_song_concert FOREIGN KEY(concert_performer,concert_date) REFERENCES concerts(performer,concert_date)
);


CREATE TABLE recorded_songs(
	track_order NUMBER(3),
	album CHAR(15),
	duration NUMBER(2),
	title VARCHAR2(50),
	author VARCHAR2(50),
	performer VARCHAR2(50),
	recording_date DATE,
	recording_engineer VARCHAR2(50),
	studio_name VARCHAR2(50) NULL,
	studio_address VARCHAR2(100) NULL,
	CONSTRAINT pk_rec_song PRIMARY KEY(track_order,album),
	CONSTRAINT fk_rec_song_album FOREIGN KEY(album) REFERENCES albums(pair),
	CONSTRAINT fk_rec_song_performer FOREIGN KEY(performer) REFERENCES performers(stage_name),
	CONSTRAINT pos_dur_rec_song CHECK(duration > 0),
	CONSTRAINT valid_dur_rec_song CHECK(duration < 90)
);


CREATE TABLE record_labels(
	name VARCHAR2(25),
	phone_number NUMBER(10),
	CONSTRAINT pos_pn_labels CHECK(phone_number > 0),
	CONSTRAINT pk_rec_label PRIMARY KEY (name)
);


CREATE TABLE attendees(
	passport VARCHAR2(14) NULL, 
	email VARCHAR2(100),
	name VARCHAR2(80) NULL,
	surname1 VARCHAR2(80) NULL,
	surname2 VARCHAR2(80) NULL,
	date_of_birth DATE NULL,
	telephone_number NUMBER(10) NULL,
	postal_address VARCHAR2(100) NULL,
	CONSTRAINT pk_attendees PRIMARY KEY (email)
);

CREATE TABLE attendance_sheet(
	concert_performer VARCHAR2(100),
	concert_date DATE,
	attendee VARCHAR2(100),
	date_of_birth DATE,
	date_of_ticket_purchase DATE,
	rfid VARCHAR2(120),
	CONSTRAINT pk_att_sheet PRIMARY KEY (rfid),
	CONSTRAINT fk_att_sheet_concert FOREIGN KEY(concert_performer,concert_date) REFERENCES concerts(performer,concert_date),
	CONSTRAINT fk_att_sheet_attendee FOREIGN KEY(attendee) REFERENCES attendees(email)
);