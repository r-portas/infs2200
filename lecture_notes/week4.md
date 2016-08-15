# Week 4 - Storage

## Storage Hierarchy

1. Primary
    - Random Access Memory
    - For currently used data
2. Secondary
    - Disks
    - For the main database
3. Tertiary
    - Tapes
    - For archiving older data

## Disks and Files
- DBMS stores information on hard disks
- This has major implications on the DBMS design
    - READ: Transfer data from disk to RAM
    - WRITE: Transfer data from RAM to disk
    - Both are high cost (slow) operations

### Magnetic Disks
- Data is stored in units called __disk blocks__ or __pages__
- Disks benefit from random access speeds over tapes
- Unlike RAM, time to retrieve a page varies depending on location on disk

### Disk Components
- Concentric rings called tracks
- One or more platter
- All tracks with the same diameter
- Each track is divided into __sectors__
- A __Block__ is multiple contiguous sectors
- Only one __head__ reads/writes at any one time
- The __arm__ assembly is moved in or out to position the head on a desired track

### Accessing a Disk Block
- Time to access (read/write) a disk block:
    1. __Seek time__: Moving arm to position disk head on track
    2. __Rotational delay__: Waiting for block to rotate under the head
    3. __Transfer time__: Moving data to/from disk surface

```
Track Capacity = Number of sectors * sector size

Surface Capacity = Number of tracks * track capacity

Disk Capacity = Number of surfaces * surface capacity

Maximum rotational delay (seconds) = 60 / Rotational Speed in RPM

Average rotational delay (seconds) = 60 / (Rotational Speed in RPM * 2)

Transfer rate = track capacity / revolution time

Average track access time = average seek time + average rotational delay + track transfer time

Average block access time = seek time + rotational delay + transfer time
```

## Data Elements
- __Field__: A database attribute (sequence of bytes)
- __Record__: Sequence of fields
- __Block__: A sequence of records
- __File__: A sequence of blocks

## Improving Access Time
- __Block Transfer__
- __Cylinder based organisation__
    - 
- __Buffering and prefetching__
- __Multiple disks__
- __Record placement__

### Block Transfer
- Data is always transferred from and to disks by blocks of bytes
- A disk block is an adjacent sequence of sectors from a single track of one platter
- Block size typically ranges from 512 bytes to 4 kilobytes
- Blocks have headers, which include:
    - Block ID
    - Role info such as data block, index block
    - Timestamp
    - Links to other blocks of the same table/file
    - Free list
- ```Blocking factor = block size / record size```
- Block spanning methods:
    - __Unspanned__: Records are not allowed to cross block boundaries
    - __Spanned__: A record can span more than one block

### Cylinder Based Organisation
- __Observation__: Data blocks in a relation are likely to be accessed together
- __Idea__: Store such blocks next to each other (same track, same cylinder)
- Blocks on the same track or cylinder effectively only involve the first seek time and the first rotational latency
- Advantages:
    - Excellent if access pattern matches storage
    - Only one process/transaction is using the disk

### Buffering and Prefetching
- __Buffering (Caching)__
    - __Idea__: Keep as many blocks in memory as possible to reduce disk accesses
    - Might run out of memory
    - Cache replacement policies
        - __LRU__: Least Recently Used
        - __LFU__: Least Frequently Used

- __Prefetching (Double Buffering)__:
    - __Situation__: Needed data is known, but the timing of the request is unknown
    - __Idea__: Speed up access by preloading needed data
    - __Cons__:
        - Requires extra main memory
        - No help if requests are random (unpredictable)


### Multiple Disks
- Data partitioning over several disks
    - __Pros__: Increase access rate
    - __Problem__: If popular data is stored on the same disk, results in request collisions
    - __Cons__: The cost of several small disks is greater than a single larger capacity disk
- Mirror Disks
    - __Pros__: Doubls read rate
    - Does not have request collisions
    - Does not slow down write requests
    - __Cons__: Pay for two disks to get the storage of one

- RAID (Redundant Arrays of Inexpensive Disks)
    - __Data Striping__: Distrubutes data transparently over multiple disks to make them appear as one single large, fast disk
    - __Bit Level Striping__: Split goups of bits over different disks
    - __Block Level Striping__ for blocks of a file
    - __Sector Level Striping__ for sectors of a block
    - __RAID Goals__:
        - Parallelize accesses so the access time is reduced
        - Combining Striping, Mirroring and Reliability
- Levels of RAID
    0. Non redundant
    1. Mirrored
    2. Memory Style ECC
    3. Bit Interleaved Parity
    4. Block Interleaved Parity
    5. Block Interleaved Distribution Parity

### Record Placement

- Records
    - Fixed length records
    - Variable length records
- Files
    - File of unordered records (Heap)
    - File of ordered records (Sorted)

#### Files of Records
- A file is a sequence of records, where each record is a collection of data values
- Records are stored on disk __blocks__
- The __blocking factor__ for a file is the average number of records stored in a disk block
- A file can have __fixed-length__ recrods or __variable length__ records
- A __file descriptor__ includes information that describe the file

### Fixed Length Records
- Pros
    - No space is needed for storing extra info for the files within records (i.e. file ending characters)
    - Equally fast access to all fields
    - Fixed field length simplifies insert, delete and update
- __Cons__
    - Block internal fragmentation (Due to unspanned organisation)
    - Record internal fragmentation (Due to using maximum length of each field)
    - More disk accesses for reading a given number of records

### Variable length records
- Pros
    - No record internal fragmentation (Saves space)
- Cons
    - Access time for field is proportional to the distance from the beginning of the record
    - Not easy to reuse space which was occupied by a deleted record
    - No space for record to __grow__ longer
