# INFS2200 Assignment
## Roy Portas - 43560846

## Task 1: Constraints

### Part A

```sql
select * from USER_CONSTRAINTS;
```

Output:
```
OWNER                                                                                                            CONSTRAINT_NAME                C TABLE_NAME
------------------------------------------------------------------------------------------------------------------------ ------------------------------ - ------------------------------
SEARCH_CONDITION
--------------------------------------------------------------------------------
R_OWNER                                                                                                          R_CONSTRAINT_NAME              DELETE_RU STATUS   DEFERRABLE     DEFERRED
------------------------------------------------------------------------------------------------------------------------ ------------------------------ --------- -------- -------------- ---------
VALIDATED     GENERATED      BAD RELY LAST_CHAN INDEX_OWNER                    INDEX_NAME                  INVALID VIEW_RELATED
------------- -------------- --- ---- --------- ------------------------------ ------------------------------ ------- --------------
S4356084                                                                                                         PK_BIRD_ID                     P BIRDS

                                                                                                                                                          ENABLED  NOT DEFERRABLE IMMEDIATE
VALIDATED     USER NAME               19/OCT/16 S4356084                       PK_BIRD_ID


OWNER                                                                                                            CONSTRAINT_NAME                C TABLE_NAME
------------------------------------------------------------------------------------------------------------------------ ------------------------------ - ------------------------------
SEARCH_CONDITION
--------------------------------------------------------------------------------
R_OWNER                                                                                                          R_CONSTRAINT_NAME              DELETE_RU STATUS   DEFERRABLE     DEFERRED
------------------------------------------------------------------------------------------------------------------------ ------------------------------ --------- -------- -------------- ---------
VALIDATED     GENERATED      BAD RELY LAST_CHAN INDEX_OWNER                    INDEX_NAME                  INVALID VIEW_RELATED
------------- -------------- --- ---- --------- ------------------------------ ------------------------------ ------- --------------
S4356084                                                                                                         PK_ORGANISATION_ID             P ORGANISATIONS

                                                                                                                                                          ENABLED  NOT DEFERRABLE IMMEDIATE
VALIDATED     USER NAME               19/OCT/16 S4356084                       PK_ORGANISATION_ID


OWNER                                                                                                            CONSTRAINT_NAME                C TABLE_NAME
------------------------------------------------------------------------------------------------------------------------ ------------------------------ - ------------------------------
SEARCH_CONDITION
--------------------------------------------------------------------------------
R_OWNER                                                                                                          R_CONSTRAINT_NAME              DELETE_RU STATUS   DEFERRABLE     DEFERRED
------------------------------------------------------------------------------------------------------------------------ ------------------------------ --------- -------- -------------- ---------
VALIDATED     GENERATED      BAD RELY LAST_CHAN INDEX_OWNER                    INDEX_NAME                  INVALID VIEW_RELATED
------------- -------------- --- ---- --------- ------------------------------ ------------------------------ ------- --------------
S4356084                                                                                                         PK_SPOTTER_ID                  P SPOTTERS

                                                                                                                                                          ENABLED  NOT DEFERRABLE IMMEDIATE
VALIDATED     USER NAME               19/OCT/16 S4356084                       PK_SPOTTER_ID


```

### Part B
```sql
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
```

Output:
```

Table altered.


Table altered.


Table altered.


Table altered.


Table altered.


Table altered.


Table altered.

```

## Task 2: Triggers

### Part A
```sql
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
```

Output: 
```
Sequence created.

Trigger created.

```

### Part B
```sql
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
```

Output:
```
Trigger created.
```

### Part C
```sql
INSERT INTO sightings (spotter_id, bird_id, latitude,
longitude, sighting_date)
VALUES (2457, 901, -28.0, 152, '09-MAR-2016');
INSERT INTO sightings (spotter_id, bird_id, latitude,
longitude, sighting_date)
VALUES (1024, 512, -25.6, 153, '09-MAR-2016');
```

Output:
```

1 row created.


1 row created.

```

### Part D
```sql
select * from sightings where sighting_date = '09-MAR-2016';
```

Output:
```
SIGHTING_ID SPOTTER_ID    BIRD_ID   LATITUDE  LONGITUDE SIGHTING_
----------- ---------- ---------- ---------- ---------- ---------
DESCRIPTION
--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     300000       2457        901        -28        152 09/MAR/16
A bird of the species Australian pied cormorant was spotted in the north-east part of the observation area

     300001       1024        512      -25.6        153 09/MAR/16
A bird of the species Mrs. Humes pheasant was spotted in the north-east part of the observation area

```
