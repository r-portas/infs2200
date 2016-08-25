# Commands

## Setup user account
```
conn sys/INFS3200 as sysdba;

create user s4356084 identified by password account unlock default tablespace "USERS" temporary tablespace "TEMP" profile "DEFAULT";

grant DBA to s4356084;

conn s4356084/password;
```

## Dump the database
```
commit;
host exp s4356084/password file=H:\Documents\infs2200\practicals\weekX.dmp owner=24356084
```

## Load database
