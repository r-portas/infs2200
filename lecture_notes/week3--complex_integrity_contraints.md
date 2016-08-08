# Week 3 - Complex Integrity Constraints

## Queries and Transactions
A Query is read only

A Update will write to the database

A Transaction is a group of queries and updates (Like a function)

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


