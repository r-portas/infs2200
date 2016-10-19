# Quiz 2 Revision

## Bitmap Indexes
- An index with elements either 0 or 1
- Size of each bitmap (in bits) is equal to the number of rows in the relation
- Number of bitmaps for a field is equal to the number of distint values of that field
    - i.e. for a field called 'states' where values are either 'QLD', 'NSW' or 'ACT', there will be three bitmaps

- Total space needed to index one field (in bits) = number of distinct values x number of rows

- File size (in bits) = record size in bits x number of rows
- In general, bitmap indexes are space efficient
- Bitmaps are not good for frequently modified data as update requires modifying all the associated bitmap indexes
- Used in warehouse datasets which are large and are not updated frequently

## Dynamic Muli-Level Index (B+ Trees)
- Because of the insertion/deletion problem, most multi-level indexes use B+ trees
- In B+ Tree data structures, each node corresponds to a disk block
- Leave space in each tree node
    - Each node is kept between half full and completely full
    - Allows efficient insertion and deletion of search values

### Internal vs Leaf nodes
- __Internal Nodes__
    - Guide the search to leaf nodes
    - Pointers to tree pointers
- __Leaf Nodes__
    - Have an entry for every value of the search field
    - Pointers are data pointers
    - Data pointers are stored on leaf nodes only

### Internal Nodes
- __Keys__
    - Keys are ordered smallest to largest
    - Some search values from the leaf nodes are repeated in the internal nodes to guide the search
    - For all search values X in the subtree pointed at by pi, X must be less than Ki and greater than or equal to K(i-1)
- __Pointers__
    - Pointers are tree pointers to blocks that are tree nodes
    - For a tree of order q:
        - Each internal node has at most q tree pointer
        - Each internal node has at least q/2 tree pointers, except for the root which can have at least two

### Leaf Nodes
- __Pointers__
    - Each pointer is a pointer to the actual data
    - If it is a key field, i.e. unique, then it points to a data block that contains the record
    - If it is a non-key field (repeated), then it points to a block containing pointers, such as a secondary index

- __Next Pointers__
    - Points to the next leaf node
    - Leaf nodes are linked to provide ordered access on the indexing field
    - Useful for range search

### Insertion and Deletion
- __Insertion__
    - Into a node that is not full is quite efficient
    - If a node is full it is split into two nodes
    - Splitting may propagate to other tree levels
- __Deletion__
    - Efficient if a node remains more than half full
    - Otherwise, it is merged with neighboring nodes

### Insertion Algorithm
```
Find correct leaf L
Put new entry onto L
If L has enough space:
    return
Else:
    redistribute entries evenly
        If L is of order p, then floor((p + 1) / 2) entries stay in L and rest move to L_new
    copy up first key in L_new into L's parent
    Insert pointer to L_new into L's parent
```

### Search
- Read one block at each level in the index
    - Number of accessed index blocks = tree height
- Total number of accessed blocks = tree height + 1
- Tree height is proportional to log entries to base fan out factor
- Fan out factor = index blocking factor = block size/entry size
- Aim to minimize entry size
- Index entry = <key entry, pointer>
- The smaller the szie of the key value, the more efficient the B+ tree (i.e. shorter)

## Query Optimisation

### Conceptual Evaluation Strategy
1. Compute the cross-product of from-list
2. Discard resulting tuples that fail qualification
3. Delete attributes that are not in select-list
4. If DISTINCT is specified, eliminate duplicate rows

- Strategy is probably the least efficient way to compute a query
- An optimizer will find more efficient strategies to compute the same answer

### Streps in Processing a Query
- Scan, Parse, Validate SQL statement
- Optimize query
- Query code generator
- Runtime DB Processor

### Operations of Relational Algebra
- SELECT
    - Selects all tuples that satify a condition

- PROJECT
    - Produces a new relation with only some of the attributes from R

- THETA JOIN
    - Produces a combination of tuples from ...

- EQUIJOIN
    - Produces all the combinations of tuples from both tables that satify a join condition without only equality comparisions

- NATURAL JOIN
    - Same as EQUIJOIN except no duplicates columns for the attribute being compared

- UNION
    - OR

- INTERSECTION
    - AND

- DIFFERENCE
    - Produces a relation that includes all tuples in one table that aren't in the other table

- CARTESIAN PRODUCT
    - Produces a relation that has every possible combination of both tables

- DIVISION
    - Produces a relation that includes all tuples that appear in the first table in combination with every tuple from the second table


### How to Implement Selection

Depends on:
- Point query
- Range query
- Conjunction
- Disjunction

### Optimizing Select

No Index, Unsorted Data: Linear Search

No Index, Sorted Data: Binary Search

Index: Use Index

Select fastest method
1. Use index
2. Use binary search
3. Use brute force linear approach

### Select with Conjunctions

- Using a composite index
    - Use if a composite index exists on the combined field
- Conjunction selection:
    - If an attribute in the conjunctive condition has an index, then:
    - Use that index to retrieve the records
    - For each retrieved recrod, check if it statisfies the remaining conditions in the conjunction

If there are multiple indexes, choose the one that retrieves the fewest records

### Selectivity

- The ratio of the number fo records that satisfy a condition to the total number of records
- Should be between 0 and 1

### Cross Product

- Each row of table 1 is paired with __each__ row of table 2
- Result has one field per field of table 1 and table 2
    - Field names inherited if possible

### Conditional Join

- Condition on the join, such as select every id which is lower than the id in the other table

### Equijoin

- Special case of conditional join where condition contains only equalities

### Natural Joins

#### Nested Loop Joins
- Essentially two for loops
- Total number of block reads = `Bt + Nt x Bs`

#### Nested Loop Join - Page at a Time
- `Bt + Bt x Bs`

#### Block Nested Loop Join
- Read a chunk of blocks from T instead of only one

```
Let buffer size be Nb memory blocks
    One block for buffering result
    One block for reading from the inner file
    Then, remaining Nb - 2
        Read as much as:
        Nb - 2 blocks at a time from the outer file
```

- Bt + (Bt/(Nb - 2)) x Bs
- Order matters, the smaller file should be the outer file

### Single Loop Join

- Only works if an index exists for one of the two joins attributes
- Cost in number of block accesses: `B(outer) + (N(outer) x (L(index) + 1))`

### Outer Join
- Join selects only tuples satisfying the join condition
- __Outer Join__
    - Left outer join keeps every tuple in the left relation
    - Right outer join keeps every tuple in the right relation
    - Full outer join keeps every tuple
- Attributes of tuples with no matching tuples are set to NULL

### Optimization of Query Trees
- Get Initial Query Tree
    1. Apply Cartesian Product of relations in __FROM__
    2. Selection and Join conditions of __WHERE__ is applied
    3. Project on attributes in __SELECT__
- Transform it into an equilvalent query tree
    - Represents a different relational expression
    - Gives the same result
    - More efficient to execute

### General Transformation Rules

- Cascade of selection
    - `A and B -> A(B)`
- Commutativity of selection
    - `A(B) = B(A)`
    - Execute the one that returns the fewest records first
- Cascade of projection
    - `A(BC) = A`
    - All but the last can be ignored
- Commuting with selection and projection
    - Move selection to the outside, so the projection is done first

### Outline of Algebraic Optimization
- Break up selections into a cascade of selection operators
- Push selection operators as far down in the tree as possible
- Convert Cartesian products into joins
- Rearrange leaf nodes so that execute first the most restrictive select operators
- Move projections as far down as possible