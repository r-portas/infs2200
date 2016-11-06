# Final Exam Review

## Concurrency Control
- Helps prevent:
    - The __lost update__ problem
    - The __dirty read__ problem
    - The __unrepeatable read__ problem

## Conflicting Operations
- A conflict happens if we have two operations such that:
    1. They belong to two different transactions
    2. They both operate on the __same data item__
    3. and __one of them is a write__

## Scheduling Transactions
- __Serial schedule__: Schedule that _does not_ interleave the actions of different transactions
- __Serializable schedule__: A schedule that is _equivalent_ to some serial execution of the transactions
- __Result Equivalent schedules__: For any database state, two schedules S1 and S2 are equivalent if the state produced by executing S1 is _identical_ to the state produced by executing S2
- A schedule __does not__ prevent deadlocks

## Lock Based Concurrency Control
- Locking is the most common synchronization method
- A __lock__ is associated with each data item in the database
- A lock on item "x" indicates that a transaction is performing an operation (read or write) on "x"
- Transaction `T` can issue the following operations on item x:
    - __read_lock(x)__
        - x is read-locked by T
        - __shared__ lock: other transactions are allowed to read x
    - __write_lock(x)__
        - x is write-locked to T
        - __exclusive__ lock: single transaction holds the lock on x
    - __unlock(x)__

## Basic Two Phase Locking (2PL)
- A scheduler following the 2PL protocol has two phases:
    1. Growing Phase
        - Whenever the scheduler receives an operation on any item, it must _acquire_ a lock on that item before executing the operation
        - No locks can be released in the phase
    2. Shrinking Phase
        - Once a scheduler has _released_ a lock for a transaction, it cannot request any additional locks on any data item for this transaction

## Conservative Two Phase Locking
- Locks all desired data items _before_ T begins execution
- If any item cannot be locked, T does not lock any item
    - Waits until all items are available for locking
- __Deadlock free protocol__
- Difficult to use in practise: Hard to _predeclare_ items

## Lock Table
- A DBMS manages locks with a lock table

## Granularity of Locks
- Locking granularity is the _size_ of the data item being locked, for example:
    - Block
    - Table
    - Tuple
- The granularity of locks is irrelevant w.r.t. _correctness_, but it is important w.r.t. _performance_

|                                   |  Fine  |  Coarse  |
| --------------------------------- | ------ | -------- |
| Lock conflict probability         | Low    | High     |
| Concurrency                       | High   | Low      |
| Overhead: Lock table size         | High   | Low      |

## Deadlock Prevention
- T locks all its data items before it begins execution
- Prevents deadlock since T never waits for data item
- The conservative two-phase locking uses this approach

## Deadlock Detection
- Deadlock Detection
    - Deadlocks are allowed to happen
    - A wait-for-graph is used to detect __cycles__
- Wait For Graph
    - Created using the lock table
    - As soon as a transaction is blocked, it is added to the graph
    - __Detect cycles__
    - One of the transactions in the cycle is rolled back
- Factors when rolling back a transaction
    - The cost of aborting a transaction
    - How long a transaction has been running
    - How long it will take a transaction to finish
    - How many deadlocks will be resolved by rolling back the transaction
    - How many times this transaction was already aborted due to deadlocks

## Timeout
- __Guess__ a deadlock rather than detecting it
- The scheduler checks __periodically__ if a transaction has been blocked for too long
    - In such a case, the scheduler assumes that the transaction is deadlocked and it is aborted
    - This method may incorrectly diagnose a situation to be a deadlock
- Advantage
    - Very simple algorithm
- Fine tuning of the timeout period
    - Long timeout: fewer mistakes but deadlock may exist for longer
    - Short timeout: quick deadlock detection but more mistakes

## Strict Two Phase Locking
- A stricter version of Basic 2PL
- Does not release exclusive(write) locks until after the transaction finishes
- Simplifies the recovery process

## Scheduling Transactions
- Result Equivalent schedules:
    - For any database state, two schedules S1 and S2 are equivalent if the state produced by executing S1 is identical to the state of produced by executing S2
- Conflict Equivalent:
    - Two schedules are said to be conflict equivalent if the order of any two conflicting operations is the same in both schedules
- Conflict Serializable (CSR)
    - A schedule S is said to be conflict serializable if it is conflict equivalent to some serial schedule

## Testing CSR
- Test for CSR by analyzing the precedence graph, called a serialization graph 

