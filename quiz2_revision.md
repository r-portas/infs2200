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
- __Deletion_
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
