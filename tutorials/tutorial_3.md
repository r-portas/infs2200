# Tutorial 3

## Integrity Constraints
- Key constraint: PK should not be null
- Entity contraint: PK should be unique
- Referential integrity contraint: FK should always be valid

## Question 1: Identify integrity constraints

A: Inserts successfully
B: Referential integrity contraint (DNum does not exist)
C: Key constraint (DNum is not unique)
D: Referential integrity contraint: (PNum is null)
E: Inserts successfully
F: Deletes successfully
G: Referential constraint: (SSN is foreign key in other tables)
H: Referential constraint: (Pnumber is a foreign key in other tables)
I: Update successful
J: Referential constraint: (SuperSSN  does not exist)
K: Update successful

## Question 2
A: Works table links Emp and Dept, deleting from Works could cause a Referential integrity constraint violation

B:
create table Emp (
    eid int not null,
    ename string not null,
    age int,
    salary real,
    primary key (eid)
)

create table Dept (
    did int not null,
    dname string,
    budget real,
    managerid int not null,
    primary key(did)
)

create table Works (
    eid int not null,
    did int not null,
    pcttime int,
    foreign key(eid) references Emp(eid),
    foreign key(did) reference Dept(did)
)

C: Manager id is not null, see above

D: insert into Emp values (101, "John Doe", 32, 15000);

E: update Emp set salary = salary + 1

F: delete from Dept where dname='Toy';
This could cause a referential integrity constraint within the Works table
