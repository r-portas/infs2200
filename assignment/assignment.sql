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
start with 300000
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
	if :NEW.latitude < -28.4 then
		/* Its less than the middle latitude, thus south */
		if :NEW.longitude < 151.25 then
			/* Its less than the middle longitude */
			select CONCAT(CONCAT('A bird of the species ', BIRD_NAME), ' was spotted in the south-west part of the observation area' )
			into :NEW.DESCRIPTION from DUAL
			inner join BIRDS
			on BIRDS.BIRD_ID = :NEW.BIRD_ID;
		else
			/* Its greater than the middle longitude */
			select CONCAT(CONCAT('A bird of the species ', BIRD_NAME), ' was spotted in the south-east part of the observation area' )
			into :NEW.DESCRIPTION from DUAL
			inner join BIRDS
			on BIRDS.BIRD_ID = :NEW.BIRD_ID;
		end if;
	else
		/* Its greater than the middle latitude */
		if :NEW.longitude < 151.25 then
			/* Its less than the middle longitude */
			select CONCAT(CONCAT('A bird of the species ', BIRD_NAME), ' was spotted in the north-west part of the observation area' )
			into :NEW.DESCRIPTION from DUAL
			inner join BIRDS
			on BIRDS.BIRD_ID = :NEW.BIRD_ID;
		else
			/* Its greater than the middle longitude */
			select CONCAT(CONCAT('A bird of the species ', BIRD_NAME), ' was spotted in the north-east part of the observation area' )
			into :NEW.DESCRIPTION from DUAL
			inner join BIRDS
			on BIRDS.BIRD_ID = :NEW.BIRD_ID;
		end if;
	end if;
	
end;
/

/* Part C */

INSERT INTO sightings (spotter_id, bird_id, latitude,
longitude, sighting_date)
VALUES (2457, 901, -28.0, 152, '09-MAR-2016');
INSERT INTO sightings (spotter_id, bird_id, latitude,
longitude, sighting_date)
VALUES (1024, 512, -25.6, 153, '09-MAR-2016');


/* Part D */
select * from sightings where sighting_date = '09-MAR-2016';

/* Task 3: Views */

/* Part A */

create or replace view V_ORGANISATION_BIRD_COUNT as select org.ORGANISATION_NAME, count(*) "bird_count"
from ORGANISATIONS org
inner join SPOTTERS sp
	on org.ORGANISATION_ID = sp.ORGANISATION_ID
inner join SIGHTINGS si
	on sp.SPOTTER_ID = si.SPOTTER_ID
group by ORGANISATION_NAME;

/* Part B */
create materialized view MV_ORGANISATION_BIRD_COUNT as select org.ORGANISATION_NAME, count(*) "bird_count"
from ORGANISATIONS org
inner join SPOTTERS sp
	on org.ORGANISATION_ID = sp.ORGANISATION_ID
inner join SIGHTINGS si
	on sp.SPOTTER_ID = si.SPOTTER_ID
group by ORGANISATION_NAME;

/* Task 4: function Based Indexes */

/* Part A */
select SIGHTING_ID, sqrt(power((LATITUDE + -28), 2) + power((LONGITUDE + 151), 2)) as DISTANCE from SIGHTINGS;

/* Part B #TODO: Verify*/
create index IDX_HEADQUARTERS_DISTANCE on SIGHTINGS(sqrt(power((LATITUDE + -28), 2) + power((LONGITUDE + 151), 2)));

/* Task 5: Execution Plan and Analysis */

/* Part A */
explain plan for select SIGHTING_ID, SPOTTER_NAME, SIGHTING_DATE 
from SIGHTINGS 
inner join SPOTTERS
	on SPOTTERS.SPOTTER_ID = SIGHTINGS.SPOTTER_ID
where SIGHTINGS.SPOTTER_ID = 1255;

SELECT PLAN_TABLE_OUTPUT FROM TABLE (DBMS_XPLAN.DISPLAY);

/* Part B */
alter table SPOTTERS
drop constraint PK_SPOTTER_ID;

explain plan for select SIGHTING_ID, SPOTTER_NAME, SIGHTING_DATE 
from SIGHTINGS 
inner join SPOTTERS
	on SPOTTERS.SPOTTER_ID = SIGHTINGS.SPOTTER_ID
where SIGHTINGS.SPOTTER_ID = 1255;

SELECT PLAN_TABLE_OUTPUT FROM TABLE (DBMS_XPLAN.DISPLAY);

/* Part C */
analyze index PK_BIRD_ID validate structure offline;
select * from INDEX_STATS;
