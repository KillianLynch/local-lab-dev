#!/bin/bash

# Sign into Oracle database as sysdba and create user
sqlplus -s sys/Welcome123@//localhost/FREEPDB1 AS SYSDBA <<EOF
CREATE USER movie IDENTIFIED BY movie;
GRANT ALL PRIVILEGES TO movie;
CREATE TABLESPACE MOVIE DATAFILE 'movie.dbf' SIZE 100M AUTOEXTEND ON;
ALTER USER movie QUOTA UNLIMITED ON MOVIE;
ALTER USER movie QUOTA UNLIMITED ON movie;
EXIT;
EOF

# Log in as the new user and enable ORDS schema
sqlplus -s movie/movie@//localhost/FREEPDB1 <<EOF
BEGIN
    ORDS.ENABLE_SCHEMA(p_enabled => TRUE, p_schema => 'MOVIE');
END;
/
EXIT;
EOF

# Start ORDS and wait for 3 seconds
ords serve &
sleep 3

# Launch URL in default web browser
xdg-open http://localhost:8080/ords/sql-developer >/dev/null 2>&1 &
