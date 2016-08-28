# Week 5 - Files and Index

Methods of arranging a file of records on external storage:
- Unordered records (Heap)
- Ordered records (Sorted)

## Unordered Files
- Simplest file structure, no order
- Also known as heap, pile or random file
- New records inserted at the end of file
    1. The last disk block is copied into buffer (memory)
    2. New record is added
    3. Block is rewritten back to disk
- Record insertion is quite efficient
- To delete a record:
    1. Find it's block
    2. Copy the block into a buffer
    3. Delete the record from the buffer
        - an extra bit is stored in each record (deletion marker)
        - set the deletion marker to 1 (invalid record)
    4. Rewrite the disk block back to disk
- What to do with unused space?
    1. Periodic reorganization: records are packed by removing deleted records
    2. Insert new records in the empty space

### Unordered Files Search
- __Linear search__ is required
- Must be searched from the start

- Search on a unique field: Read half of records (on average)
- Search non-unique field: All records must be read
- Range seach on any field: All records must be read

## Ordered Files
- Files records are kept sorted by the values of an ordering field
- Also called sorted or sequential files
- If the ordering field is a key field of the file/table, then:
    - The ordering field has unique fields
    - The ordering field is called ordering key
- Search for a record on its ordering field value is quite efficient (binary search)

### Binary search
- Halves the problem space each iteration
- IO Reads: log2(n)

### Ordered Files Search

- Search on ordering key: Binary search
- Search on non-ordering key: Linear search
- Range search on ordering key: Binary first, then sequential access until end of range

### Ordered Files Insert

- Insertion is an __expensive__ operation, all records must be in correct order
- To insert a record:
    - Find its correct position in file
    - Make space in the file to insert the record in that position
    - On average, half the blocks of the file must be moved
        1. Read these blocks
        2. Move records among them
        3. Rewrite them back to disk

## Comparison of I/O costs

| File type  | Scan    | Equality Search    | Range Search                 | Insert      |
| ---------- | ------- | ------------------ | ---------------------------- | ----------- |
| __Heap__   | B       | 0.5B               | B                            | 2           |
| __Sorted__ | B       | log2(B)            | log2(B) + # matching blocks  | log2(B) + B |


## Index

- An index is an auxiliary file that makes it more efficient to search for a record in the data file
- The index is usually specified on __one field__ of the file (although it could be specified on several fields)
- One form of an index is a file of entries: `<field value, pointer to record>`
- The index is called __access path__ or __access method__

## Index Structures
- Single level indexes
    - Primary indexes
    - Clustering indexes
    - Secondary indexes
- Multi level indexes

## Primary Index
- Defined on an __ordered__ data file
- The data file is ordered on a key field
- A __primary index__ is an ordered file
- Fixed length with 2 fields: `<Key, Pointer_to_disk_block>`

### Advantages
- Occupies much less space than a data file
- Binary search is more efficient on a index file

### Data access
- Binary ssearch on the index yields a pointer to the file record
- Extra IO is needed to fetch data

- To search a record:
    - Binary search in the index file
    - Fetch the block from the data file

## Clustering Index

- Defined on an ordered data file
- The data file is ordered on a non-key field
- One entry for __each distinct value__ of the field
- The index entry points to the first data block that contains records with that field value
- It is another example of __sparse__ index
- Record insertion and deletion causes problems
    - Because the data records are physically ordered
    - Same problem happens in primary index
- To overcome the problem of insertion
    - Reserve a whole block for each distinct value of the clustering field
    - Place all recrods that have the same value in one block

## Secondary Index on key field
- Include one index entry for each record in the data file
- An index entry points to a data blcok that contains the record
- It is a __dense index__
    - Number of index entries = number of data records
- Advantages:
    - The index is still smaller than the data file
    - Allows binar search

## Secondary index on non-key field
- Two level index
- The 1st level (top level) contains one entry for each distinct value of the indexing field
    - Each index entry (1st level) points to an index block that contains a set of record pointers
    - Each record pointer (2nd level) points to a data block that contains a record with that field value

## Summary

|                    | Number of entries                | Dense/Sparse  |
| ------------------ | -------------------------------- | ------------- |
| Primary            | Number of blocks in data file    | Sparse        |
| Clustering         | Number of distinct values        | Sparse        |
| Secondary (key)    | Number of records in data file   | Dense         |
| Seconary (non-key) | Number of values for both levels | Dense         |
