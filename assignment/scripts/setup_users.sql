conn sys/INFS3200 as sysdba;

create user s4356084 identified by password account unlock default tablespace "USERS" temporary tablespace "TEMP" profile "DEFAULT";

grant DBA to s4356084;

conn s4356084/password;

show user;
