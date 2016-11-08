# 2015 Final Exam

## Q1

### 1.1) Two Phase Locking

Two phase locking has two parts:

1. Growing phase, where it acquires locks to resources, cannot release locks in this phase
2. Shrinking phase, where it releases the locks, cannot acquire more locks in this phase

### 1.2) List and explain ACID

A: Atomicity, either all operations happen or none happen
C: Consistency, satifies the constraints on the data
I: Isolation, Concurrent and serial operations should yield the same result
D: Durability, data is persistant

### 1.3) Explain the 3 main heuristics used in algebraic query optimization

### 1.4) In the timeout mechanism for handling deadlocks, compare the pros and cons of long timeout vs short timeout

__Long timeout__:
    - Less likely to make mistakes
    - Deadlocks will take longer to be stopped

__Short timout__:
    - More likely to make mistakes
    - Quickly stops deadlocks

## Q2

### 2.1) Consider the B+ tree

### 2.2)

```
Table has 100 000 rows
Row size 200
4000 bytes per block
20 bytes per entry

Total size: 100 000 * 20
            2 000 000

Number of blocks:   2 000 000 / 4000
                    500
```

### 2.3)

```
20 data entries per block
100 pointers per block
100 000 tuples

number of leaf blocks:  100 000 / 20
                        5000

50 blocks for the next level
1 block for the root level

3 levels, including leaf

```

## Q3


