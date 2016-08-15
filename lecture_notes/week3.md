# Week 3 - Complex Integrity Constraints

## Queries and Transactions
A Query is read only

A Update will write to the database

A Transaction is a group of queries and updates (Like a function). A transaction needs to be executed completely to ensure the database integrity.

## ACID

### Properties

- Atomicity
Either all operations for a transaction happen or none at all

- Consistency
Satifies the integrity constraints on the data

- Isolation
Concurrent and serial transactions should yield the same result

- Durability
The result of a transaction should be permanent

### Modes of Constraints Enforcement

- NOT DEFERRABLE or IMMEDIATE
    - Evalution is performed at input time
    - By default contraints are created as NON DEFERRABLE
    - It __cannot__ be changed during execution

- DEFERRED
    - Contraints are not evaluated until commit time

- DEFERRABLE
    - It can be changed within a transaction to be DEFERRED using SET CONSTRAINT

Modes can be specified when a table is created:
- INITIALLY IMMEDIATE: Constraint validation to happen immediately
- INITIALLY DEFERRED: Constraint validation to defer until commit

## CHECK and DOMAIN
CHECK is used to enforce a constraint on a table column. Used within the CREATE TABLE command.

CHECK prohibits an operation on a table that would violate the constraint. 

DOMAIN is used to specify a new variable type and can be used to enforce a contraint onto it

## ASSERTIONS
An ASSERTION is a global contraint

Created by specifing a query which should never exist in the database and checks for it.

## Triggers
A trigger consists of three parts
- Events
- Condition
- Action

Triggers are similiar to assertions, but trigger an action when the constraint fails

