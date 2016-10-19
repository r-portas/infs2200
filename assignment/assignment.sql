/* Task 1 */

/* Part A */
select * from USER_CONSTRAINTS;

/* Part B */
alter table SPOTTERS
add constraint FK_ORG_ID_TO_ORG_ID
foreign key (organisation_id) references ORGANISATIONS (organisation_id);

alter table SIGHTINGS
add constraint PK_SIGHTING_ID
PRIMARY KEY (sighting_id);

alter table SIGHTINGS
add constraint FK_SPOTTER_ID_TO_SPOTTER_ID
foreign key (spotter_id) references SPOTTERS (spotter_id);

alter table SIGHTINGS
add constraint FK_BIRD_ID_TO_BIRD_ID
foreign key (bird_id) references BIRDS (bird_id);

alter table ORGANISATIONS
modify ORGANISATION_NAME 
constraint NN_ORGANISATION_NAME NOT NULL;

alter table SPOTTERS
modify SPOTTER_NAME 
constraint NN_SPOTTER_NAME NOT NULL;

alter table SIGHTINGS
add constraint CK_SIGHTING_DATE
check (SIGHTING_DATE <= TO_DATE('2016-12-31', 'YYYY-MM-DD'));


/* Task 2 */

/* Part A */
create sequence SEQ_SIGHTINGS
start with 30000
increment by 1;

create or replace trigger TR_SIGHTING_ID
before insert on "SIGHTINGS"
for each row
begin
	select "SEQ_SIGHTINGS".NEXTVAL into :NEW.sighting_id from DUAL;
end;
/

/* Part B */
create or replace trigger TR_SIGHTING_DESC
before insert on "SIGHTINGS"
for each row
begin
	select CONCAT(CONCAT('A bird of species ', BIRD_NAME), ' was spotted in the ' )
	into :NEW.DESCRIPTION from DUAL
	inner join BIRDS
	on BIRDS.BIRD_ID = :NEW.BIRD_ID;
end;
/

/* Part C */
INSERT INTO sightings (spotter_id, bird_id, latitude,
longitude, sighting_date)
VALUES (2457, 901, -28.0, 152, '09-MAR-2016');
INSERT INTO sightings (spotter_id, bird_id, latitude,
longitude, sighting_date)
VALUES (1024, 512, -25.6, 153, '09-MAR-2016');